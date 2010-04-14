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
        @brand ||= Factory.build(:brand)
        Brand.stubs(:find).returns(@brand)
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
      @brands ||= 3.times.map { Factory.build(:brand) }
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
        Brand.expects(:paginate).with(){has_entry(:page, 2)}.returns(@brands)
        get :index, :page => 2
      }
      tests.call
      should_assign_to(:brands){@brands.paginate(:per_page => BrandsController::PER_PAGE)}
    end
  end
  
  context "get comments" do
    setup {
      @brand ||= Factory.build(:brand)
      Brand.stubs(:find).returns(@brand)
      Brand.any_instance.stubs(:comments).returns(3.times.map { Factory.stub(:comment) })
      get :comments, :id => @brand.to_param
    }
    
    should_respond_with :success
    should_assign_to(:comments)
    should_assign_to(:brand)
  end
  
  context "get fans" do
    setup {
      @brand ||= Factory.build(:brand)
      Brand.stubs(:find).returns(@brand)
      Brand.any_instance.stub_chain(:votes, :positive_score, :descending).returns([Factory.build(:vote)])
      Vote.any_instance.stubs(:paginate)
      get :fans, :id => @brand.to_param
    }
    
    should_respond_with :success
    should_assign_to(:brand)
    should_assign_to(:votes)
  end
  
  context "an anonymous user" do
    context "be denied for action" do
      %w[edit update destroy new create].each do |action|
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
      should_assign_to :brand
      should_respond_with :success
      should_render_form_for :brand
    end
    
    context "posting to create" do
      context "with invalid data" do
        setup {
          Brand.any_instance.stubs(:save).returns(false)
          post :create, :brand => {}
        }
        should_assign_to :brand, :class => Brand
        should_respond_with :success
        should_render_template :new
        should_not_set_the_flash
      end
      
      context "with valid data" do
        setup {
          
          Brand.any_instance.expects(:save).returns(true).once
          Brand.any_instance.stubs(:id).returns(1002)
          Brand.any_instance.stubs(:to_param).returns('1002-brand')
          Brand.any_instance.stubs(:new_record?).returns(false)
          post :create, :brand => {}
        }
        should_assign_to :brand, :class => Brand
        should_redirect_to("the brand page"){ brand_path('1002-brand') }
        should set_the_flash.to(/created/i)
      end
    end
  end
  
  
end