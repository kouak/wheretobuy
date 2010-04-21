require 'test_helper'

class TaggingsControllerTest < ActionController::TestCase
  context "as an anonymous user" do
    %w[new create].each do |action|
      context "request #{action}" do
        setup {
          get action
        }
        should_be_denied
      end
    end
  end
  
  context "as a logged in user" do
    setup {
      login_as :active_user
    }
    context "with invalid brand_id" do
      setup {
        Brand.expects(:find).with('invalid').raises(ActiveRecord::RecordNotFound)
      }
      
      %w[new create].each do |action|
        context "request #{action}" do
          setup {
            get action, :brand_id => 'invalid'
          }
          should_respond_with 404
        end
      end
    end
    context "with valid brand_id" do
      setup {
        @target ||= Factory.stub(:brand)
        Brand.expects(:find).with('valid').returns(@target)
      }
      context "get new" do
        setup {
          @target.expects(:owner_tag_list_on).with(current_user, :tags).returns(TagList.new)
          get :new, :brand_id => 'valid'
        }
        should_respond_with :success
        should_not_set_the_flash
        should_render_template :new
        should_render_form_for(:tagging)
      end
      
      context "post create" do
        context "with valid data" do
          setup {
            current_user.expects(:tag).with(@target, {:on => :tags, :with => 'tag1, tag2'}).returns(true)
            post :create, :brand_id => 'valid', :tagging => {:tag_list => 'tag1, tag2'}
          }
          should_redirect_to('the brand tags page'){ brand_tags_path(@target) }
          should_set_the_flash_to(/tagged successfully/i)
        end
        context "with invalid data" do
          setup {
            current_user.expects(:tag).with(@target, {:on => :tags, :with => 'tag1, tag2'}).returns(false)
            post :create, :brand_id => 'valid', :tagging => {:tag_list => 'tag1, tag2'}
          }
          should_respond_with :success
          should_render_template :new
          should_not_set_the_flash
          should_render_form_for(:tagging)
        end
      end
    end
  end
  
end
