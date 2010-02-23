require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  def test_should_be_invalid
    assert_equal false, Vote.new.valid?
  end
  
  def test_unassociated_should_be_invalid
    b = Factory.create(:brand)
    v = Vote.new(:score => 1)
    assert_equal false, b.votes << v
  end
  
  def test_associated_should_be_valid
    b = Factory.create(:brand)
    u = Factory.create(:user)
    v = Vote.new(:score => 1, :voter => u)
    assert b.votes << v
  end
  
  def test_should_only_exist_one_vote_per_votable_and_user
    b = Factory.create(:brand)
    u = Factory.create(:user)
    v = Vote.new(:score => 1, :voter => u)
    assert b.votes << v
    v = Vote.new(:score => 1, :voter => u)
    assert_equal b.votes << v, false
  end
end
