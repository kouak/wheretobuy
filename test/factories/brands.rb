Factory.define :brand do |u|
  u.sequence(:name) { |n| "brand#{n}-name" }
  u.association :creator, :factory => :user
end