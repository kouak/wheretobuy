require 'test_helper'

class ActivationsControllerTest < ActionController::TestCase
  
  context "a registered user" do
    setup {
      login_as :active_user
    }
    
    %w[new create activate].each do |action|
      context "requesting #{action}" do
        setup { get action }
        should_be_denied(:flash => /be logged out/i, :redirect => 'root_path')
      end
    end
  end
  
  context "an anonymous user" do
    context "getting new" do
      setup { get :new }
      should_respond_with :success
      should_render_template :new
    end
    
    context "posting to create" do
      context "with inexistant user" do
        setup {
          User.stubs(:find_by_email)
          User.expects(:find_by_email).returns(nil)
          post :create
        }
        
        should set_the_flash.to(/does not exist/i)
        should_redirect_to("the new action"){ new_activation_path }
      end
      
      context "with active user" do
        setup {
          User.stubs(:find_by_email)
          User.expects(:find_by_email).returns(Factory.build(:active_user))
          post :create
        }
        
        should set_the_flash.to(/already active/i)
        should_redirect_to("the new action"){ new_activation_path }
      end
      
      context "with unactive user" do
        setup {
          User.stubs(:find_by_email)
          User.expects(:find_by_email).returns(Factory.build(:unactive_user))
          User.any_instance.stubs(:deliver_activation_instructions!)
          User.any_instance.expects(:deliver_activation_instructions!).once
          post :create
        }
        
        should set_the_flash.to(/activation instructions have been sent/i)
        should_redirect_to_home
      end
    end
    context "getting activate" do
      context "with inexistant activation token" do
        setup {
          User.stubs(:find_using_perishable_token).with('pouet', anything).returns(nil)
          get :activate, :activation_code => 'pouet'
        }
        
        should set_the_flash.to(/invalid activation code/i)
        should_redirect_to_home 
      end
      context "with already used activation token" do
        setup {
          User.stubs(:find_using_perishable_token).with('pouet', anything).returns(Factory.build(:active_user))
          get :activate, :activation_code => 'pouet'
        }
        
        should set_the_flash.to(/invalid activation code/i)
        should_redirect_to_home 
      end
      
      context "with valid activation token" do
        setup {
          User.stubs(:find_using_perishable_token).with('pouet', anything).returns(Factory.build(:unactive_user))
        }
        context "with successful activation" do
          setup {
            User.any_instance.stubs(:activate).returns(true)
            User.any_instance.stubs(:deliver_activation_confirmation!)
            UserSession.expects(:create).at_least_once
            get :activate, :activation_code => 'pouet'
          }
          should set_the_flash.to(/has been confirmed/i)
          should_redirect_to("the edit account page"){ edit_account_path }
        end
      end
    end
    
  end
end