Factory.define :vote do |u|
  u.created_at 2.weeks.ago
  u.updated_at 1.week.ago
  u.association :voter, :factory => :user
end

Factory.define :vote_up, :parent => :vote do |u|
  u.score 1
end

Factory.define :vote_down, :parent => :vote do |u|
  u.score -1
end