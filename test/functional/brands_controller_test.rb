require 'test_helper'

class BrandsControllerTest < ActionController::TestCase
  
  context "get show with" do
    context "no brand id set" do
      setup { get :show }
      should_respond_with 404
    end
  
    context "unexistant brand requested" do
      setup { get :show, :id => '23342-wrong-brand' }
      should_respond_with 404
    end
    
    context "existant brand" do
      setup {
        @brand = Factory.create(:brand)
        get :show, :id => @brand.to_param
      }
      
      before_should "increment_pageviews" do
        Brand.any_instance.expects(:increment_pageviews).once
      end
      should_assign_to(:brand){@brand}
      should_assign_to(:comments)
      should_respond_with :success
      should_render_with_layout :brand_profile
      should_render_template :show
    end
  end
  
  context "get index" do
    setup {
      @brands = 3.times.map { Factory.build(:brand) }
    }
    
    tests = lambda {
      should_respond_with :success
      should_render_with_layout :application
      should_render_template :index
    }
    
    context "without page set" do
      setup { 
        Brand.expects(:paginate).returns(@brands)
        get :index
      }
      tests.call
      should_assign_to(:brands){@brands.paginate(:per_page => BrandsController::PER_PAGE)}
    end
    
    context "with page set" do
      setup {
        Brand.expects(:paginate).with(has_entries(:page => 2)).returns(@brands)
        get :index, :page => 2
      }
      tests.call
      should_assign_to(:brands){@brands.paginate(:per_page => BrandsController::PER_PAGE)}
    end
    

  end
  
  
end