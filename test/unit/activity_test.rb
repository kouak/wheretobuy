require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  
  should_validate_presence_of :author_id, :target_id, :target_type
  should_validate_numericality_of :author_id, :target_id
  
  should_belong_to :author
  should_belong_to :target
  
  context "adding comment" do
    context "with invalid comment" do
      should_raise(ArgumentError) do
        Activity.added_comment(nil)
      end
      should_raise(ArgumentError) do
        Activity.added_comment(Factory.build(:active_user))
      end
      should_raise(ArgumentError) do
        Activity.added_comment(Factory.build(:comment))
      end
    end
    context "with valid comment" do
      setup {
        author ||= Factory.create(:active_user)
        brand ||= Factory.create(:brand)
        @comment = Factory.create(:comment, :resource => brand, :author => author)
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
