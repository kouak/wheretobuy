class Friendship < ActiveRecord::Base
  attr_accessible :state, :user_id, :friend_id
  
  belongs_to :user
  belongs_to :friend, :class_name => 'User', :foreign_key => :friend_id
  
  validates_presence_of :user_id, :friend_id
  validates_uniqueness_of :friend_id, :scope => :user_id
  
  validates_each :user_id do |record, attr, value|
    record.errors.add attr, 'can not be same as friend' if record.user_id.eql?(record.friend_id)
  end
  
  state_machine :initial => :pending do
    after_transition :on => :approve, :do => :create_reciprocal_friendship
    
    event :approve do
      transition :pending => :approved
    end
  end
  
  def create_reciprocal_friendship
    reciprocal_friendship = self.class.find_or_initialize_by_user_id_and_friend_id(friend_id, user_id) # find any existing reciprocal friendship or create a new one
    return true if reciprocal_friendship.approved? # Ok this reciprocal friendship already exists
    reciprocal_friendship.state = 'approved'
    reciprocal_friendship.save!
  end
  
end
