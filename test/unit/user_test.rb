require 'test_helper'

class UserTest < ActiveSupport::TestCase
  subject { Factory(:user) }
  
  should_validate_uniqueness_of :username, :email
  
  should_allow_values_for :email, "test@example.com"
  should_not_allow_values_for :email, "test"
  should_have_many :comments
  
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
