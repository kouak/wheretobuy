require 'test_helper'

class BrandTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Factory.build(:brand).valid?
  end
  
  def test_uniqueness_validation
    brand = Factory.create(:brand)
    brand1 = Brand.new(:name => brand.name)
    assert !brand1.valid?
  end
  
end
