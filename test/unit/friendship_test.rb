require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  
  def test_associations
    u1, u2 = Factory.create(:user), Factory.create(:user)
    
    fr = u1.friendships.create!(:friend_id => u2.id)
    
    assert_equal [fr], u1.friendships
    assert_equal u2, u1.friendships.first.friend
    assert_equal u1, fr.user
    assert_equal [], u1.reverse_friends
    assert_equal u1, u2.reverse_friends.first
    
    assert_equal [u2], u1.friends
    assert_equal [], u1.approved_friends
    
    fr.update_attribute(:state, 'approved')
    
    u1.reload
    assert_equal [u2], u1.friends
    assert_equal [u2], u1.approved_friends
    
  end
  
  def test_user_and_friend_can_not_be_same
    fr = Friendship.new(:user_id => 1, :friend_id => 1)
    assert(!fr.valid?, "Friendship should not be valid")
    assert fr.errors.on(:user_id)
  end
  
  def test_new_friendship_should_be_pending
    u1, u2 = Factory.create(:user), Factory.create(:user)
    fr = u1.friendships.create!(:friend_id => u2.id)
    
    assert fr.pending?
  end
  
  def test_only_one_friendship_per_user_and_friend
    fr = Friendship.create!(:user_id => 1, :friend_id => 2)
    fr2 = Friendship.new(:user_id => 1, :friend_id => 2)
    assert !Friendship.new(:user_id => 1, :friend_id => 2).valid?
  end
  
  
  def test_only_one_request_per_user_couple
    u1, u2 = Factory.create(:user), Factory.create(:user)
    
    fr = u1.friendships.create!(:friend_id => u2.id)
    
    assert fr.pending?
    
    assert !u2.friendships.new(:friend_id => u1.id).valid?
  end
  
  
  def test_approve_creates_symmetric_friendships
    u1, u2 = Factory.create(:user), Factory.create(:user)
    
    fr = u1.friendships.create!(:friend_id => u2.id)
    
    fr.approve!
    
    assert bilateral_friendship_between(u1, u2)
    
    assert_equal [fr], u1.friendships
    assert_equal [u1], u2.friends
    
  end
  
  def test_deleted_friendship_can_be_requested_again
    u1, u2 = Factory.create(:user), Factory.create(:user)
    
    fr = u1.friendships.create!(:friend_id => u2.id)
    fr.approve! # Here we have a two-way friendship between u1 and u2
    
    u2.friendships.first.destroy # u2 doesn't want to be u1's friend anymore
    
    fr = u2.friendships.new(:friend_id => u1.id) # but he has regret
    
    assert fr.valid?
    assert fr.pending?
    
  end
  
  def test_named_scope
    u1, u2 = Factory.create(:user), Factory.create(:user)
    
    fr = u1.request_friendship_with(u2)
    fr.save!
    
    assert_equal 1, u1.friendships.pending.count
    assert_equal 0, u1.friendships.approved.count
    
    assert_equal 1, Friendship.with_user(u1).count
    assert_equal 1, Friendship.with_user(u1.id).count
    assert_equal 0, Friendship.with_friend(u1).count
    assert_equal 0, Friendship.with_friend(u1.id).count
    
    fr.approve!
    assert_equal 0, u1.friendships.pending.count
    assert_equal 1, u1.friendships.approved.count
    assert_equal 1, Friendship.with_friend(u1.id).with_user(u2).count
    assert_equal 1, Friendship.with_friend(u2).with_user(u1.id).count
  end
  
  def test_requested_again_friendship_approval_should_not_recreate_relationship
    u1, u2 = Factory.create(:user), Factory.create(:user)
    
    fr = u1.friendships.create!(:friend_id => u2.id)
    fr.approve! # Here we have a two-way friendship between u1 and u2
    u2.friendships.first.destroy # u2 doesn't want to be u1's friend anymore
    fr = u2.friendships.new(:friend_id => u1.id) # but he has regret
    
    fr.approve! # u1 approves
    
    assert bilateral_friendship_between(u1, u2)
  end
  
  def test_friendship_request
    u1 = Factory.create(:user)
    u2 = Factory.create(:user)
    
    friendship = u1.request_friendship_with(u2)
    
    assert Friendship, friendship.class
    assert friendship.pending?
    assert_equal u1, friendship.user
    assert_equal u2, friendship.friend
  end
  
  def self.include_requestable_context(&block)
    context "requestable" do
      
      FriendshipTest.class_eval do
        def should_be_requestable(u1 = @u1, u2 = @u2)
          assert be_requestable?(u1, u2)
        end
        
        def should_not_be_requestable(u1 = @u1, u2 = @u2)
          assert !be_requestable?(u1, u2)
        end
  
        def pending_friendship(u1 = @u1, u2 = @u2)
          Friendship.create(:user_id => @u1.id, :friend_id => @u2.id)
        end

        def approved_friendship(u1 = @u1, u2 = @u2)
          pending_friendship(u1, u2).approve!
        end
      end
    
      setup {
        @u1, @u2 = Factory.create(:user), Factory.create(:user)
        Friendship.delete_all
        FriendshipTest.class_eval &block
      }
  
      should "not be requestable with self" do
        should_not_be_requestable(@u1, @u1)
      end
            
      should "be requestable between two unconnected users" do
        should_be_requestable
      end
  
      should "not be requestable between 2 users with a pending request" do
        pending_friendship
        should_not_be_requestable
        should_not_be_requestable(@u2, @u1)
      end
  
      should "not be requestable between 2 connected users" do
        approved_friendship
        should_not_be_requestable
        should_not_be_requestable(@u2, @u1)
      end
  
      should "be requestable if there is only a one way reverse_friendship" do
        approved_friendship
        @u1.friendships.first.destroy # @u1 is not friend with @u2 anymore but @u2 is still connected with @u1
        should_be_requestable
      end
  
      should "not be requestable if there is only a one way friendship" do
        approved_friendship
        @u2.friendships.first.destroy
        should_not_be_requestable
      end
    end
  end
  
  context "requestable_between?" do
    include_requestable_context do
      def be_requestable?(u1 = @u1, u2 = @u2)
        Friendship.requestable_between?(u1, u2)
      end
    end
  end
  
  context "new() save" do
    include_requestable_context do
      def be_requestable?(u1 = @u1, u2 = @u2)
        fr = Friendship.new(:user_id => u1.id, :friend_id => u2.id)
        fr.save
      end
    end
  end
  
  context "create" do
    include_requestable_context do
      def be_requestable?(u1 = @u1, u2 = @u2)
        !Friendship.create(:user_id => u1.id, :friend_id => u2.id).new_record?
      end
    end
  end
  
  context "user can_request_friendship" do
    include_requestable_context do
      def be_requestable?(u1 = @u1, u2 = @u2)
        u1.can_request_friendship?(u2)
      end
    end
  end
  
  private
  
  def bilateral_friendship_between(u1, u2)
    
    raise ArgumentError unless (u1.is_a?(User) and u2.is_a?(User))
    
    u2.friends.include?(u1) && u1.friends.include?(u2) && u1.reverse_friends.include?(u2) && u2.reverse_friends.include?(u1) \
    && Friendship.approved.find(:all, :conditions => {:user_id => [u1.id, u2.id], :friend_id => [u1.id, u2.id]}) # check consistency
    
  end
  
end
