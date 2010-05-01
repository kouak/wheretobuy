require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  context "get show" do
    context "with inexistant user" do
      setup {
        User.expects(:find).with('invalid').raises(ActiveRecord::RecordNotFound)
        get :show, :id => 'invalid'
      }
      should_respond_with 404
      should_not_set_the_flash
    end
    context "with existant user" do
      setup {
        @user = Factory.stub(:active_user)
      }
      context "with wrong slug" do
        setup {
          User.expects(:find).with('wrong-slug').returns(@user)
          get :show, :id => 'wrong-slug'
        }
        should_redirect_to('the user page with a right slug'){ user_path(@user) }
        should_not_set_the_flash
      end
      context "with right slug" do
        setup {
          User.expects(:find).with(@user.to_param).returns(@user)
          User.any_instance.stub_chain(:comments, :all).returns([])
          Activity.stub_chain(:recent, :regarding_user, :find).returns([])
          get :show, :id => @user.to_param
        }
        
        should_respond_with :success
        should_render_template :show
        should_assign_to :user, :class => User
        should_assign_to :activities
        should_assign_to :comments
        should_not_set_the_flash
      end
    end
  end
  
  context "get friends" do
    setup {
      user = Factory.stub(:active_user)
      User.expects(:find).with(user.to_param).returns(user)
      user.expects(:approved_friendships).returns([])
      get :friends, :id => user.to_param
    }
    should_respond_with :success
    should_render_template :friends
    should_assign_to :user, :class => User
    should_assign_to :friendships
    should_not_set_the_flash
  end
  
  context "get activity" do
    setup {
      user = Factory.stub(:active_user)
      User.expects(:find).with(user.to_param).returns(user)
      Activity.stub_chain(:recent, :regarding_user, :find).returns([])
      get :activity, :id => user.to_param
    }
    should_respond_with :success
    should_render_template :activity
    should_assign_to :user, :class => User
    should_assign_to :activities
    should_not_set_the_flash
  end
  
  context "get comments" do
    setup {
      user = Factory.stub(:active_user)
      User.expects(:find).with(user.to_param).returns(user)
      user.expects(:comments).returns([])
      get :comments, :id => user.to_param
    }
    should_respond_with :success
    should_render_template :comments
    should_assign_to :user, :class => User
    should_assign_to :comments
    should_not_set_the_flash
  end
  
  context "get favorite brands" do
    setup {
      user = Factory.stub(:active_user)
      User.expects(:find).with(user.to_param).returns(user)
      user.stub_chain(:sent_votes, :for_votable_class, :descending, :positive_score).returns([])
      get :favorite_brands, :id => user.to_param
    }
    
    should_respond_with :success
    should_render_template :favorite_brands
    should_assign_to :user, :class => User
    should_assign_to :favorite_brands
    should_not_set_the_flash
    
  end
  
  
  
end