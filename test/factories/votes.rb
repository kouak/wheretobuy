Factory.define :vote do |u|
  u.created_at 2.weeks.ago
  u.updated_at 1.week.ago
  u.association :voter, :factory => :user
end