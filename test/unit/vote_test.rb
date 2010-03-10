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
  
  def test_add_vote
    b = Factory.create(:brand)
    u = Factory.create(:user)
    v = Vote.add_vote(u, b, 1)
    assert_equal 1, v.score
    
    v = Vote.add_vote(u, b, -1)
    assert v.object_id.to_i
  end
  
  def test_del_vote
    b = Factory.create(:brand)
    u = Factory.create(:user)
    v = Vote.add_vote(u, b, 1)
    assert_equal 1, Vote.for_voter(u).for_votable(b).count
    
    v = Vote.add_vote(u, b, 0)
    assert_equal 0, Vote.for_voter(u).for_votable(b).count
  end
  
  def test_should_only_exist_one_vote_per_votable_and_user
    b = Factory.create(:brand)
    u = Factory.create(:user)
    v = Vote.new(:score => 1, :voter => u)
    assert b.votes << v
    v = Vote.new(:score => 1, :voter => u)
    assert_equal b.votes << v, false
  end
  
  # test acts_as_voter
  
  def test_user_as_voter
    assert Factory.create(:user).is_voter?
  end
  
  def test_vote_for
    u = Factory.create(:user)
    b = Factory.create(:brand)
    v = u.vote_for(b)
    assert_equal 1, v.score
  end
  
  def test_vote_against
    u = Factory.create(:user)
    b = Factory.create(:brand)
    v = u.vote_against(b)
    assert_equal -1, v.score
  end
  
  def test_vote_nil
    u = Factory.create(:user)
    b = Factory.create(:brand)
    v = u.vote_for(b)
    assert_equal 1, v.score
    u.vote_nil(b)
    assert_equal u.sent_votes.for_votable(b).count, 0
  end
  
  # test acts_as_votable
  
  def test_brand_as_votable
    assert Factory.create(:brand).is_votable?
  end
  
  def test_score
    b = Factory.create(:brand)
    u = Factory.create(:user)
    u2 = Factory.create(:other_user)
    
    assert_equal 0, b.score
    
    u.vote_for(b)
    b.reload
    assert_equal 1, b.score
    
    u2.vote_for(b)
    b.reload
    assert_equal 2, b.score
    
    u.vote_nil(b)
    b.reload
    assert_equal 1, b.score
    
    u2.vote_against(b)
    b.reload
    assert_equal -1, b.score
    
  end
end
