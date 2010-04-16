Factory.define :user do |u|
  u.sequence(:email) { |n| "user#{n}@blabla.com" }
  u.sequence(:username) { |n| "user#{n}" }
  u.password 'secret'
  u.password_confirmation 'secret'
  u.created_at 2.weeks.ago
  u.updated_at 1.week.ago
end

Factory.define :other_user, :class => 'User' do |u|
  u.email 'email@blablabla.com'
  u.username  'other_user'
  u.password 'secret'
  u.password_confirmation 'secret'
  u.created_at 2.weeks.ago
  u.updated_at 1.week.ago
end

Factory.define :active_user, :parent => :user do |u|
  u.active 1
end

Factory.define :unactive_user, :parent => :user do |u|
  u.active false
end

Factory.define :inactive_user, :parent => :user do |u|
  u.active false
end