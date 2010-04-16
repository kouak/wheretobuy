require 'test_helper'

class PasswordResetsControllerTest < ActionController::TestCase
  
  context "as a logged in user" do
    setup {
      login_as :active_user
    }
    %w[new create edit update].each do |action|
      context "requesting #{action}" do
        setup { get action }
        should_be_denied(:flash => /be logged out/i, :redirect => 'root_path')
      end
    end
  end
  
  context "as an anonymous user" do
    context "get new" do
      setup { get :new }
      should_respond_with :success
      should_render_template :new
      should_render_form_for :password_reset
    end
    
    context "post create" do
      context "with invalid email" do
        setup {
          User.stubs(:find_by_email).with('invalid').returns(nil)
          post :create, :password_resets => {:email => 'invalid'}
        }
        should_set_the_flash_to(/does not exist/i)
        should_redirect_to('the home page'){ root_url }
      end
      
      context "with email belonging to inactive user" do
        setup {
          User.stubs(:find_by_email).with('valid').returns(Factory.stub(:inactive_user))
          post :create, :password_resets => {:email => 'valid'}
        }
        should_set_the_flash_to(/activated yet/i)
        should_redirect_to('the home page'){ root_url }
      end
      
      context "with valid email belonging to active user" do
        setup {
          User.stubs(:find_by_email).with('valid').returns(Factory.stub(:active_user))
          User.any_instance.expects(:deliver_password_reset_instructions!).once
          post :create, :password_resets => {:email => 'valid'}
        }
        should_set_the_flash_to(/instructions .* have been emailed/i)
        should_redirect_to('the home page'){ root_url }
      end
    end
    
    %w[edit update].each do |action|
      context "request #{action} with invalid token" do
        setup {
          User.stubs(:find_using_perishable_token).with('invalid').returns(nil)
          get action, :token => 'invalid'
        }
        should_set_the_flash_to(/could not locate your account/i)
        should_redirect_to('the home page'){ root_url }
      end
    end
    
    context "get edit" do
      context "with valid token" do
        setup {
          User.stubs(:find_using_perishable_token).with('valid').returns(Factory.stub(:active_user))
          get :edit, :token => 'valid'
        }
        should_respond_with :success
        should_not_set_the_flash
        should_render_template :edit
        should_render_form_for :user
      end
    end
    
    context "put update" do
      context "with valid token" do
        setup {
          @target ||= Factory.stub(:active_user)
          User.stubs(:find_using_perishable_token).with('valid').returns(@target)
        }
        context "with invalid data" do
          setup {
            @target.expects(:save).returns(false).once
            put :update, :token => 'valid', :user => {:password => 'bla', :password_confirmation => 'blabla'}
          }
          should_not_set_the_flash
          should_respond_with :success
          should_render_template :edit
          should_render_form_for :user
        end
        context "with valid data" do
          setup {
            @target.expects(:save).returns(true).once
            UserSession.stub_chain(:create, :save)
            put :update, :token => 'valid', :user => {:password => 'bla', :password_confirmation => 'bla'}
          }
          should_redirect_to('the home page'){ account_url }
          should_set_the_flash_to(/password successfully updated/i)
        end
      end
    end
  end
end