require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  
  context "as an anonymous user" do
    context "get new" do
      setup {
        get :new
      }
      should_respond_with :success
      should_not_set_the_flash
      should_render_template :new
      should_render_form_for :user_session
    end
    
    context "post create" do
      context "with invalid data" do
        setup {
          UserSession.any_instance.expects(:save).returns(false).once
          post :create, :user_session => {}
        }
        should_not_set_the_flash
        should_respond_with :success
        should_render_template :new
        should_render_form_for :user_session
      end
      context "with valid data" do
        setup {
          UserSession.any_instance.expects(:save).returns(true).once
          post :create, :user_session => {}
        }
        should_set_the_flash_to(/login successful/i)
        should_respond_with :redirect
      end
    end
    
    context "delete destroy" do
      setup {
        delete :destroy
      }
      should_be_denied
    end
  end
  
  context "as a logged in user" do
    setup {
      login_as :active_user
    }
    %w[new create].each do |action|
      context "request #{action}" do
        setup {
          get action
        }
        should_be_denied(:flash => /be logged out/i, :redirect => 'root_path')
      end
    end
    
    context "delete destroy" do
      setup {
        user_session.expects(:destroy).once
        delete :destroy
      }
      should_set_the_flash_to(/logout successful/i)
      should_redirect_to('the home page'){ root_url }
    end
  end
  
end