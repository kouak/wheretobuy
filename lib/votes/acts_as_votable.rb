module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module Voteable
      module Votable
        def self.included(base)
          base.extend(ClassMethods)
        end
      
        module ClassMethods
          def acts_as_votable
            has_many :votes, :as => :votable
            has_many :voters, :source => :voter, :through => :votes
            has_many :fans, :source => :voter, :through => :votes, :conditions => ["votes.score > ?", 0]
            has_many :haters, :source => :voter, :through => :votes, :conditions => ["votes.score < ?", 0]
            
            include ActiveRecord::Acts::Voteable::Votable::InstanceMethods
            extend ActiveRecord::Acts::Voteable::Votable::SingletonMethods
          
          end
        

        end
      
        module SingletonMethods
          def is_votable?
            true
          end
          
          def recalculate_fans_counts!
            self.all.each do |b|
              return false unless b.recalculate_fans_count!
            end
            true
          end
        end
      
        module InstanceMethods
          
          def is_votable?
            true
          end

          # All time popularity
          def popularity
            self.try(:comments_count).to_i + self.score*10 + self.try(:visits).to_i
          end

          # Last X days popularity
          def hype
            self.try(:comments).recent(1.week.ago).count
          end


          # Pageviews should be used for popularity
          def visits
            if attribute_present?(:pageviews)
              pageviews
            end
          end

          # Vote score
          def score
            votes.inject(0) do |sum, v|
              sum + v.score
            end
          end

          def vote_for(voter) # +1 vote
            vote_on_with_score(voter, 1)
          end

          def vote_against(voter) # -1 vote
            vote_on_with_score(voter, -1)
          end

          def vote_nil(voter) # remove vote
            Vote.find(:first, :conditions => [
              "voter_id = ? AND votable_id = ? AND votable_type = ?",
              self.id, votable.id, votable.class.name]
            ).try(:destroy)
          end

          # explicit
          def increment_pageviews
            increment(:pageviews)
          end
          
          def fans_for_profile(limit = 6)
            limit = limit.to_i || 6
            self.fans.find(:all, :offset => ( self.fans.count * rand ).to_i, :limit => limit)
          end
          
          def recalculate_fans_count!
            raise StatementInvalid unless has_attribute?(:fans_count)
            
            update_attributes!(:fans_count => fans.count)
            reload
          end

          private
          def vote_on_with_score(votable, score)
            raise ArgumentError, "votable not defined" unless votable.respond_to?(:votes)
            raise ArgumentError, "score = 0" if score.to_i == 0

            @vote = votable.votes.find(:first, :conditions => {:voter_id => self.id})
            if @vote.nil?
              @vote = Vote.add_vote(:score => score, :voter => self, :votable => votable)
            else
              @vote.score = score
              @vote.save
            end
          end
        end
      end
    end
  end
end


ActiveRecord::Base.send(:include, ActiveRecord::Acts::Voteable::Votable)