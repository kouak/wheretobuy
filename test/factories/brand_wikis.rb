Factory.define :brand_wiki, :default_strategy => :build do |u|
  u.bio "This is a biography"
  u.version_comment "First version"
  u.association :brand, :factory => :brand
  u.created_at Time.now
  u.updated_at Time.now
end