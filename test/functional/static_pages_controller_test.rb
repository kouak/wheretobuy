require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  
  context "get home" do
    setup {
      User.stubs(:all).returns([])
      Brand.stubs(:featured).returns([])
      City.stubs(:featured).returns([])
      get :home
    }
    should_assign_to :users
    should_assign_to :brands
    should_respond_with :success
    should_not_set_the_flash
    should_render_template :home
  end
  
end