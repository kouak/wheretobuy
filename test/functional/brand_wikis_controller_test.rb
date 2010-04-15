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
    
    context "without a brand wiki" do
      setup {
        Brand.any_instance.stubs(:brand_wiki)
      }
      
      [:show, :history, :diff].each do |action|
        context "get #{action}" do
          setup { get action }
          should_set_the_flash_to(/contribute/i)
          should_redirect_to("the edit page"){ edit_brand_brand_wiki_url(@brand) }
        end
      end
    end
    
    context "with an existing brand wiki" do
      setup {
        @brand_wiki = Factory.build(:brand_wiki, :brand_id => @brand.id)
        Brand.any_instance.stubs(:brand_wiki).returns(@brand_wiki)
        BrandWiki.any_instance.stubs(:find_version).returns(@brand_wiki)
        BrandWiki.any_instance.stubs(:version).returns(3)
      }
      
      context "get show" do
        setup { get :show }
        should_respond_with :success
        should_assign_to :last_version
        should_assign_to :brand, :class => Brand
        should_assign_to :brand_wiki, :class => BrandWiki
      end
      
      context "get edit" do
        setup {
          login_as :active_user
          get :edit
        }
        context "with version" do
          setup {
            login_as :active_user
            BrandWiki.any_instance.expects(:find_version).returns(@brand_wiki)
            get :edit, :version => 3
          }
          
          should_respond_with :success
          should_assign_to :brand, :class => Brand
          should_assign_to :brand_wiki, :class => BrandWiki
        end
        
        should_respond_with :success
        should_assign_to :brand, :class => Brand
        should_assign_to :brand_wiki, :class => BrandWiki
      end
      
      context "get history" do
        setup {
          BrandWiki.any_instance.expects(:history).returns([])
          get :history
        }
        should_respond_with :success
        should_assign_to :brand, :class => Brand
        should_assign_to :brand_wiki, :class => BrandWiki
        should_assign_to :versions
      end
      
      context "get diff" do
        setup {
          BrandWiki.any_instance.expects(:differences_between).returns({'version' => [1, 2]})
          get :diff
        }
        should_respond_with :success
        should_assign_to :brand, :class => Brand
        should_assign_to :brand_wiki, :class => BrandWiki
        should_assign_to :changes
      end
      
      context "put update" do
        setup { login_as :active_user }
        context "with invalid data" do
          setup {
            BrandWiki.any_instance.expects(:save).returns(false).once
            put :update, :brand_wiki => {}
          }
          should_assign_to :brand, :class => Brand
          should_assign_to :brand_wiki, :class => BrandWiki
          should_respond_with :success
          should_render_template :edit
          should_not_set_the_flash
        end
        
        context "with valid data" do
          setup {
            BrandWiki.any_instance.expects(:save).returns(true).once
            Brand.any_instance.stubs(:id).returns(1002)
            Brand.any_instance.stubs(:to_param).returns('1002-brand')
            Brand.any_instance.stubs(:new_record?).returns(false)
            put :update, :brand_wiki => {}
          }
          should_assign_to :brand, :class => Brand
          should_assign_to :brand_wiki, :class => BrandWiki
          should_redirect_to("the brand wiki page"){ brand_path('1002-brand') }
          should_set_the_flash_to(/edited/i)
        end
      end
    end
  end
    
  
end
