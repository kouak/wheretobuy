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
    v = Vote.add_vote(:voter => u, :votable => b, :score => 1)
    assert_equal 1, v.score
    
    v = Vote.add_vote(:voter => u, :votable => b, :score => -1)
    assert v.object_id.to_i
  end
  
  def test_del_vote
    b = Factory.create(:brand)
    u = Factory.create(:user)
    v = Vote.add_vote(:voter => u, :votable => b, :score => 1)
    assert_equal 1, Vote.for_voter(u).for_votable(b).count
    
    v = Vote.add_vote(:voter => u, :votable => b, :score => 0)
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
    assert_equal Vote.find(:all, :conditions => {:votable_id => b.id, :votable_type => 'brand', :voter_id => u.id}).count, 0
  end
  
  def test_voted?
    u = Factory.create(:user)
    b = Factory.create(:brand)
    
    assert_equal [false, false, false], [u.voted_on?(b), u.voted_for?(b), u.voted_against?(b)]
    
    u.vote_for(b)
    u.reload
    assert_equal [true, true, false], [u.voted_on?(b), u.voted_for?(b), u.voted_against?(b)]
    
    u.vote_nil(b)
    u.reload
    assert_equal [false, false, false], [u.voted_on?(b), u.voted_for?(b), u.voted_against?(b)]
    
    u.vote_against(b)
    u.reload
    assert_equal [true, false, true], [u.voted_on?(b), u.voted_for?(b), u.voted_against?(b)]
    
  end
  
  def test_favorites
    b1, b2, b3 = Factory.create(:brand), Factory.create(:brand), Factory.create(:brand)
    u = Factory.create(:user)
    
    u.vote_for(b1)
    u.vote_for(b3)
    
    b1.reload
    b3.reload
    
    assert_equal [b1, b3], u.favorites(b1.class)
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
  
  def test_fans
    b = Factory.create(:brand)
    u = Factory.create(:user)
    
    assert_equal [], b.fans
    
    u.vote_for(b)
    b.reload
    assert_equal [u], b.fans
    
    u.vote_against(b)
    b.reload
    assert_equal [], b.fans
  end
  
  def test_fans_count
    b = Factory.create(:brand)
    u = Factory.create(:user)
    u2 = Factory.create(:other_user)
    
    assert_equal 0, b.fans_count
    
    u.vote_for(b)
    b.reload
    assert_equal 1, b.fans_count
    
    u.vote_against(b)
    b.reload
    assert_equal 0, b.fans_count
    
    u.vote_for(b)
    b.reload
    u2.vote_for(b)
    b.reload
    assert_equal 2, b.fans_count
    
    u.vote_for(b)
    b.reload
    assert_equal 2, b.fans_count
    
    # tricky case now
    u.vote_against(b)
    b.reload
    assert_equal 1, b.fans_count
    
    u2.vote_nil(b)
    b.reload
    assert_equal 0, b.fans_count
    
  end
  
  def test_recalculate_fans_count!
    
    brand = Factory.create(:brand)
    
    brand.update_attributes!(:fans_count => -34)
    
    assert Brand.recalculate_fans_counts!
    
    brand.reload
    
    assert_equal 0, brand.fans_count
    
    user = Factory.create(:user)
    other_user = Factory.create(:other_user)
    
    user.vote_for(brand)
    other_user.vote_for(brand)
    
    brand.recalculate_fans_count!
    assert_equal 2, brand.fans_count
    
  end
  
  context "activity logger" do
    setup {
      @brand = Factory.create(:brand, :creator => nil)
      @voter = Factory.stub(:user)
      @vote = @voter.vote_for(@brand)
    }
    should_create :vote
    should_create :activity
    should "have correct data" do
      assert_equal({:type => 'voted', :score => 1}, @brand.reload.activities.recent.first.data)
    end
  end
end
