Factory.define :friendship do |u|
  u.created_at 2.weeks.ago
  u.updated_at 1.week.ago
  u.association :user, :factory => :active_user
  u.association :friend, :factory => :active_user
end

Factory.define :pending_friendship, :parent => :friendship do |u|
  u.state 'pending'
end

Factory.define :approved_friendship, :parent => :friendship do |u|
  u.state 'approved'
end