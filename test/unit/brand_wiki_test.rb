require 'test_helper'

class BrandWikiTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert BrandWiki.new.valid?
  end
end
