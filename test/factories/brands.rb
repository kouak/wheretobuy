Factory.define :brand do |u|
  u.name 'brand-name'
  u.brand_types {|b| [b.association :brand_type]}
end