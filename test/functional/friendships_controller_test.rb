require 'test_helper'

class FriendshipsControllerTest < ActionController::TestCase
  context "as an anonymous user" do
    context "post create" do
      setup { post :create }
      should_be_denied
    end
    context "put approve" do
      setup { put :approve }
      should_be_denied
    end
    context "delete destroy" do
      setup { delete :destroy }
      should_be_denied
    end
  end
  
  context "as a logged in user" do
    setup { login_as :active_user }
    context "with an invalid user_id" do
      context "post create" do
        setup { post :create }
        should_respond_with 404
      end
      context "put approve" do
        setup { put :approve }
        should_respond_with 404
      end
      context "delete destroy" do
        setup { delete :destroy }
        should_respond_with 404
      end
    end
  end
  
  context "as a logged in user" do
    setup {
      login_as :active_user
    }
    context "with valid target" do
      setup {
        @target ||= Factory.stub(:active_user)
        User.stubs(:find).with('valid id').returns(@target)
      }
      context "post create" do
        setup {
          User.any_instance.stubs(:request_friendship_with).returns(Factory.stub(:pending_friendship))
        }
        context "with invalid data" do
          setup {
            Friendship.any_instance.stubs(:save).returns(false)
            post :create, :user_id => 'valid id'
          }
          should_set_the_flash_to(/couldn't request friendship/i)
          should_redirect_to('the user page'){user_path(@target)}
        end
        context "with valid data" do
          setup {
            Friendship.any_instance.stubs(:save).returns(true)
            post :create, :user_id => 'valid id'
          }
          should_set_the_flash_to(/requested friendship/i)
          should_redirect_to('the user page'){user_path(@target)}
        end
      end
      context "put approve" do
        context "with invalid friendship" do
          setup {
            @target.stub_chain(:friendships, :pending, :with_friend, :find).raises(ActiveRecord::RecordNotFound)
            put :approve, :user_id => 'valid id', :id => 'invalid'
          }
          should_respond_with 404
          should_not_set_the_flash
        end
        context "with existant friendship" do
          setup {
            @friendship ||= Factory.stub(:friendship, :user => @target, :friend => current_user)
            @target.stub_chain(:friendships, :pending, :with_friend, :find).returns(@friendship)
            @friendship.expects(:approve!)
            put :approve, :user_id => 'valid id', :id => 'valid'
          }
          should_redirect_to('the user page'){ user_url(@target) }
          should_set_the_flash_to(/now friend with/i)
        end
      end
      context "delete destroy" do
        context "with invalid friendship" do
          setup {
            current_user.stub_chain(:friendships, :with_friend, :find).raises(ActiveRecord::RecordNotFound)
            delete :destroy, :user_id => 'valid id', :id => 'invalid'
          }
          should_respond_with 404
        end
        
        context "with pending friendship" do
          setup {
            @friendship ||= Factory.stub(:pending_friendship, :user => @target, :friend => current_user)
            current_user.stub_chain(:friendships, :with_friend, :find).returns(@friendship)
            @friendship.expects(:destroy)
            delete :destroy, :user_id => 'valid id', :id => 'valid'
          }
          should_redirect_to('the user page'){user_url(@target)}
          should_set_the_flash_to(/cancelled friend request/i)
        end
        
        context "with approved friendship" do
          setup {
            @friendship ||= Factory.stub(:approved_friendship, :user => @target, :friend => current_user)
            current_user.stub_chain(:friendships, :with_friend, :find).returns(@friendship)
            @friendship.expects(:destroy)
            delete :destroy, :user_id => 'valid id', :id => 'valid'
          }
          should_redirect_to('the user page'){user_url(@target)}
          should_set_the_flash_to(/cancelled friendship/i)
        end
      end
    end
  end
end