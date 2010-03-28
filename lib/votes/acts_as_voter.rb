module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module Voteable
      module Voter
        def self.included(base)
          base.extend(ClassMethods)
        end
      
        module ClassMethods
          def acts_as_voter
            has_many :sent_votes, :class_name => "Vote", :foreign_key => "voter_id"
          
            include ActiveRecord::Acts::Voteable::Voter::InstanceMethods
            extend ActiveRecord::Acts::Voteable::Voter::SingletonMethods
          
          end
        

        end
      
        module SingletonMethods
          def is_voter?
            true
          end
        end
      
        module InstanceMethods
          
          def is_voter?
            true
          end
        
          def vote_for(votable) # +1 vote
            vote_on_with_score(votable, 1)
          end

          def vote_against(votable) # -1 vote
            vote_on_with_score(votable, -1)
          end

          def vote_nil(votable) # remove vote
            vote_on_with_score(votable, 0)
          end

          def voted_for?(votable)
            0 < Vote.count(:all, :conditions =>
              [
                "voter_id = ? AND score > 0 AND votable_id = ? AND votable_type = ?",
                self.id, votable.id, votable.class.name
              ]
            )
          end

          def voted_against?(votable)
            0 < Vote.count(:all, :conditions =>
              [
                "voter_id = ? AND score < 0 AND votable_id = ? AND votable_type = ?",
                self.id, votable.id, votable.class.name
              ]
            )
          end

          def voted_on?(votable)
            0 < Vote.count(:all, :conditions =>
              [
                "voter_id = ? AND votable_id = ? AND votable_type = ?",
                self.id, votable.id, votable.class.name
              ]
            )
          end

          private
          def vote_on_with_score(votable, score)
            Vote.add_vote(:voter => self, :votable => votable, :score => score)
          end
        end
      end
    end
  end
end


ActiveRecord::Base.send(:include, ActiveRecord::Acts::Voteable::Voter)
