Factory.define :comment do |u|
  u.sequence(:body) { |n| "This is a comment n°#{n} !" }
  u.status 1
  u.created_at Time.now
end