require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  
  context "get show" do
    context "with valid id" do
      setup { 
        @comment = Factory.stub(:comment, :resource => Factory.build(:brand), :author => Factory.build(:active_user))
        Comment.expects(:find).returns(@comment)
        get :show, :id => @comment.id
      }
      
      should_assign_to :comment, :class => Comment
      should_respond_with :success
      should_not_set_the_flash
      should_render_template :show
    end
    
    context "with invalid id" do
      setup {
        get :show, :id => 'id not set'
      }
      
      should_respond_with 404
    end
  end
  
  context "get index" do
    setup { get :index }
    should_respond_with 404
  end
  
  context "get edit" do
    context "with invalid id" do
      setup {
        get :edit, :id => 'id not set'
      }
      
      should_respond_with 404
    end
    
    context "with valid id" do
      setup { 
        @comment = Factory.stub(:comment, :resource => Factory.build(:brand), :author => Factory.build(:active_user))
        Comment.expects(:find).returns(@comment)
        get :edit, :id => @comment.id
      }
      
      should_assign_to :comment, :class => Comment
      should_respond_with :success
      should_not_set_the_flash
      should_render_template :edit
    end
  end
  
  
  context "get new" do
    context "with no parent resource set" do
      setup { get :new }
      should_respond_with 404
    end
    
    context "with invalid parent resource" do
      setup { get :new, :brand_id => 'invalid brand id'}
      should_respond_with 404
    end
    
    context "with valid parent resource" do
      setup {
        @resource ||= Factory.stub(:brand)
        Brand.stubs(:find).returns(@resource)
        get :new, :brand_id => @resource.id
      }
      
      should_respond_with :success
      
    end
  end
  
  context "put update" do
    context "with invalid id" do
      setup { put :update, :id => 'invalid id' }
      
      should_respond_with 404
    end
    
    context "with valid id" do
      setup {
        @comment = Factory.stub(:comment, :resource => Factory.build(:brand), :author => Factory.build(:active_user))
        Comment.stubs(:find).returns(@comment)
      }
      
      context "with valid data" do
        setup {
          Comment.any_instance.expects(:update_attributes).returns(true)
          put :update, :id => @comment.id, :comment => {:body => 'blablabla'}
        }
        
        should_redirect_to("the comment page"){ comment_path(@comment) }
        should set_the_flash.to(/updated/i)
      end
      
      context "with invalid data" do
        setup {
          Comment.any_instance.expects(:update_attributes).returns(false)
          put :update, :id => @comment.id, :comment => {:body => 'blablabla'}
        }
        
        should_respond_with :success
        should_render_template :edit
      end
    end
  end
end