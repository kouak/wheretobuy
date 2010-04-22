require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  should_validate_presence_of :author, :resource_type, :resource_id
  
  context "on create" do
    setup {
      @resource ||= Factory.create(:brand)
      @author ||= Factory.create(:active_user)
    }
    context "without activity" do
      setup {
        Activity.stub_chain(:added_comment, :save).returns(true)
        @comment = Comment.create(:body => 'test test', :author => @author, :resource => @resource)
      }
      should_create :comment
    end
    
    context "with valid activity" do
      setup { 
        @comment = Comment.create(:body => 'test test', :author => @author, :resource => @resource)
      }
      should_create :comment
      should_create :activity
      should_change("activity count") { @resource.activities.count }
      should_change("comment count") { @resource.comments.count }
      should_change("cached comment count") { @resource.reload.comments_count }
    end
    
    context "with invalid activity" do
      setup {
        Activity.any_instance.expects(:save).returns(false)
        @comment = Comment.new(:body => 'test test', :author => @author, :resource => @resource)
      }
      should "raise exception" do
        assert_raise(Exceptions::ActivityError) { @comment.save }
      end
    end
  end
end
