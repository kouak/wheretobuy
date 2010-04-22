require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  
  should_validate_presence_of :author_id, :target_id, :target_type
  should_validate_numericality_of :author_id, :target_id
  
  should_belong_to :author
  should_belong_to :target
  
  
  context "tagging a brand" do
    setup {
      author ||= Factory.create(:active_user)
      @brand = Factory.create(:brand, :creator => nil)
      author.tag(@brand, :with => 'a tag', :on => :tags)
    }
    should_create :tagging
    should_create :activity
    
    should_change('the activity count'){ Activity.count }
    should "have the right data" do
      assert_equal({:type => 'tagged', :taglist => TagList.from('a tag')}, @brand.activities.first.data)
    end
  end
  
  context "voting for brand" do
    context "with invalid vote" do
      should "raise ArgumentError" do
        assert_raise(ArgumentError) { Activity.voted(nil, Factory.build(:active_user)) }
        assert_raise(ArgumentError) { Activity.voted(Factory.build(:brand), Factory.build(:active_user)) }
        assert_raise(ArgumentError) { Activity.voted(Factory.build(:vote)) }
      end
    end
    context "with valid vote" do
      setup {
        author ||= Factory.create(:active_user)
        @brand = Factory.stub(:brand)
        @vote = Factory.stub(:vote_up, :votable => @brand, :voter => author)
        @activity = Activity.voted(@vote)
      }
      should "be valid" do
        assert @activity.valid?
      end
      should "save successfully" do
        assert @activity.save
      end
      should "have valid serialized data" do
        @activity.save
        assert_equal({:type => 'voted', :score => @vote.score}, Activity.find(@activity.id).data)
      end
    end
  end
  
  
  context "editing brand_wiki" do
    context "with invalid brand_wiki" do
      should "raise ArgumentError" do
        assert_raise(ArgumentError) { Activity.edited_brand_wiki(nil, Factory.build(:active_user)) }
        assert_raise(ArgumentError) { Activity.edited_brand_wiki(Factory.build(:active_user), Factory.build(:active_user)) }
        assert_raise(ArgumentError) { Activity.edited_brand_wiki(Factory.build(:brand_wiki)) }
      end
    end
    context "with valid brand_wiki" do
      setup {
        author ||= Factory.create(:active_user)
        @brand_wiki = Factory.stub(:brand_wiki)
        @activity = Activity.edited_brand_wiki(@brand_wiki, author)
      }
      should "be valid" do
        assert @activity.valid?
      end
      should "save successfully" do
        assert @activity.save
      end
      should "have valid serialized data" do
        @activity.save
        assert_equal({:type => 'edited brand wiki', :version => @brand_wiki.version}, Activity.find(@activity.id).data)
      end
    end
  end
  
  context "creating brand" do
    context "with invalid brand" do
      should "raise ArgumentError" do
        assert_raise(ArgumentError) { Activity.added_brand(nil, Factory.build(:active_user)) }
        assert_raise(ArgumentError) { Activity.added_brand(Factory.build(:active_user), Factory.build(:active_user)) }
        assert_raise(ArgumentError) { Activity.added_brand(Factory.build(:brand), Factory.build(:active_user)) }
      end
    end
    context "with valid comment" do
      setup {
        author ||= Factory.create(:active_user)
        @brand = Factory.stub(:brand)
        @activity = Activity.added_brand(@brand, author)
      }
      should "be valid" do
        assert @activity.valid?
      end
      should "save successfully" do
        assert @activity.save
      end
      should "have valid serialized data" do
        @activity.save
        assert_equal({:type => 'created brand'}, Activity.find(@activity.id).data)
      end
    end
  end
  
  context "adding comment" do
    context "with invalid comment" do
      should "raise ArgumentError" do
        assert_raise(ArgumentError) { Activity.added_comment(nil) }
        assert_raise(ArgumentError) { Activity.added_comment(Factory.build(:active_user)) }
        assert_raise(ArgumentError) { Activity.added_comment(Factory.build(:comment)) }
      end
    end
    context "with valid comment" do
      setup {
        author ||= Factory.create(:active_user)
        brand ||= Factory.create(:brand)
        @comment = Factory.stub(:comment, :resource => brand, :author => author)
        @activity = Activity.added_comment(@comment)
      }
      should "be valid" do
        assert @activity.valid?
      end
      should "save successfully" do
        assert @activity.save
      end
      should "have valid serialized data" do
        @activity.save
        assert_equal({:type => 'added comment', :comment_id => @comment.id}, Activity.find(@activity.id).data)
      end
    end
  end
end
