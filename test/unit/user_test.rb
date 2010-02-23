require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Factory.build(:user).valid?
  end
  
  def test_add_vote
    b = Factory.create(:brand)
    voter = Factory.create(:user)
    assert voter.vote_for(b)
    assert b.votes.count == 1
  end
  
  def test_add_vote_with_wrong_input
    voter = Factory.create(:user)
    assert_raises(ArgumentError) { voter.vote_for(nil) }
    assert_raises(ArgumentError) { voter.vote_for(Factory.create(:brand), nil) }
  end
  
  def test_voted_on?
    voter = Factory.create(:user)
    b = Factory.create(:brand)
    
    assert_equal false, voter.voted_on?(b)
    
    voter.vote_for(b)
    assert voter.voted_on?(b)
  end
  
  def test_single_vote_per_user_and_voteable
    voter = Factory.create(:user)
    b = Factory.create(:brand)
    assert_equal 0, b.votes.count
    
    voter.vote_for(b)
    assert_equal 1, b.votes.count
    
    voter.vote_against(b)
    assert_equal 1, b.votes.count
    
  end
  
end
