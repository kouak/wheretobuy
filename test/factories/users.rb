Factory.define :user do |u|
  u.sequence(:email) { |n| "user#{n}@blabla.com" }
  u.sequence(:username) { |n| "user#{n}" }
  u.password 'secret'
  u.password_confirmation 'secret'
end

Factory.define :other_user, :class => 'User' do |u|
  u.email 'email@blablabla.com'
  u.username  'other_user'
  u.password 'secret'
  u.password_confirmation 'secret'
end