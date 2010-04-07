require 'test_helper'

class BrandWikisControllerTest < ActionController::TestCase
  
  context "no brand id set" do
    setup { get :show }
    should_respond_with 404
  end
  
  context "with a valid brand" do
    setup {
      @brand = Factory.build(:brand)
      Brand.stubs(:find).returns(@brand)
    }
  end
    
  
end
