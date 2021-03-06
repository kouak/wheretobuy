require 'test_helper'

class AccountControllerTest < ActionController::TestCase
  
  context "an anynomous user" do
    context "getting new" do
      setup { get :new }
      should_assign_to :user
      should_respond_with :success
      should_render_form_for :user
    end
    
    context "posting to create" do
      context "with invalid data" do
        setup {
          User.any_instance.stubs(:save).returns(false)
          post :create, :user => {}
        }
        should_assign_to :user, :class => User
        should_respond_with :success
        should_render_template :new
        should_not_set_the_flash
      end
      
      context "with valid data" do
        setup {
          User.any_instance.stubs(:save).returns(true)
          post :create, :user => {}
        }
        should_assign_to :user, :class => User
        should_redirect_to_home
        should_set_the_flash_to(/created/i)
      end
    end
    
    context "be denied for action" do
      %w[show edit update destroy friends].each do |action|
        context "#{action}" do
          setup { get action }
          should_be_denied
        end
      end
    end
  end
  
  context "a registered user" do
    setup {
      login_as :active_user
    }
    
    context "getting new" do
      setup { get :new }
      should_be_denied(:flash => /be logged out/i, :redirect => 'root_path')
    end
    
    context "posting create" do
      setup { post :create }
      should_be_denied(:flash => /be logged out/i, :redirect => 'root_path')
    end
    
    context "getting show" do # show my account
      setup { get :show }
      should_respond_with :success
      should_assign_to(:user){ @u }
    end
    
    %w[edit edit_email edit_password edit_profile].each do |action|
      context "getting #{action}" do
        setup { get action }
        should_respond_with :success
        should_assign_to(:user){ @u }
        should_assign_to(:selected_tab)
        should_render_template(action.to_sym)
        unless action == 'edit'
          should_render_form_for(:user)
        end
      end
    end
    
    context "getting friends" do
      setup { get :friends }
      should_respond_with :success
      should_assign_to(:selected_tab)
      should_assign_to(:user){ @u }
    end
    
    context "putting to update" do
      context "with invalid data" do
        setup {
          User.any_instance.stubs(:update_attributes).returns(false)
          put :update, :user => {}
        }
        should_assign_to :user, :class => User
        should_respond_with :success
        should_render_template :edit
        should_not_set_the_flash
      end
      
      context "with valid data" do
        setup {
          User.any_instance.stubs(:update_attributes).returns(true)
          put :update, :user => {}
        }
        should_assign_to :user, :class => User
        should_redirect_to('the account page'){ account_url }
        should_set_the_flash_to(/updated/i)
      end
    end
    
    context "putting to destroy" do
      setup {
        User.any_instance.stubs(:destroy).returns(true)
        put :destroy, :user => {}
      }
      
      should_redirect_to_home
      should_set_the_flash_to(/deleted/i)
    end
  end
end