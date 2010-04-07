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
        should set_the_flash.to(/created/i)
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
      activate_authlogic
      @u = Factory.create(:active_user)
      UserSession.create(@u)
    }
    
    context "getting new" do
      setup { get :new }
      should_be_denied(:flash => /be logged out/i, :redirect => 'root_path')
    end
    
    context "putting create" do
      setup { post :create }
      should_be_denied(:flash => /be logged out/i, :redirect => 'root_path')
    end
    
    context "getting show" do # show my account
      setup { get :show }
      should_respond_with :success
      should_assign_to(:user){ @u }
    end
    
    
    %w[edit friends].each do |action|
      context "getting #{action}" do
        setup { get action }
        should_respond_with :success
        should_assign_to(:user){ @u }
      end
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
        should set_the_flash.to(/updated/i)
      end
    end
    
    context "putting to update" do
      setup {
        User.any_instance.stubs(:destroy).returns(true)
        put :destroy, :user => {}
      }
      
      should_redirect_to_home
      should set_the_flash.to(/deleted/i)
    end
  end
end