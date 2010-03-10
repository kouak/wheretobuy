require 'test_helper'

class BrandTypeTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Factory.build(:brand_type).valid?
  end
end
