require 'test_helper'

class BrandTest < ActiveSupport::TestCase
  
  should_belong_to :creator
  
  should_have_many :comments
  should_have_many :activities
  should_have_one :brand_wiki
  
  context "with an existant record" do
    setup { Factory.create(:brand) }
    should_validate_uniqueness_of :name
  end
  
  context "on create" do
    setup { @brand = Brand.new(:name => 'blablabla') }
    context "without activity" do
      setup {
        Activity.stub_chain(:added_brand, :save).returns(true)
        @brand.save
      }
      should_create :brand
    end
    
    context "with activity" do
      context "without creator" do
        setup {
          @brand = Brand.new(:name => 'blablabla')
          @brand.save
        }
        should_create :brand
        should_not_change('the activity count'){ @brand.activities.count }
      end
      
      context "with creator" do
        setup {
          @brand = Brand.create(:name => 'blablabla', :creator => Factory.build(:user))
        }
        should_create :brand
        should_create :activity
        should_change('the activity count') { @brand.activities.count }
      end
      
    end
    
  end
end
