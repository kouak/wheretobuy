require 'test_helper'

class BrandTypesTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert BrandTypes.new.valid?
  end
end
