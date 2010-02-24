# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

require 'open-uri'

User.delete_all
User.find_by_sql('delete from sqlite_sequence where name = "users"')
User.create!(:email => 'benjamin.beret@gmail.com', :password => 'secret', :password_confirmation => 'secret', :sex => User::MALE).activate!

Country.delete_all
Country.find_by_sql('delete from sqlite_sequence where name = "countries"')
open("http://openconcept.ca/sites/openconcept.ca/files/country_code_drupal_0.txt") do |countries|
  countries.read.each_line do |country|
    code, name = country.chomp.split("|")
    Country.create!(:name => name)
  end
end

City.delete_all
City.find_by_sql('delete from sqlite_sequence where name = "cities"')
[
  {:name => 'Paris', :country => 'France'},
  {:name => 'London', :country => 'United Kingdom'},
  {:name => 'New-York', :country => 'United States'},
].each do |c|
  country = Country.find_by_name(c[:country])
  City.create!(:name => c[:name], :country_id => country.try(:id))
end


# Brands
Brand.delete_all
Brand.find_by_sql('delete from sqlite_sequence where name = "brands"')
[
  {:id => 1, :name => 'A.P.C'},
  {:id => 2, :name => 'Rick Owens'}
].each do |b|
  Brand.create!(b)
end

# Votes
Vote.delete_all
[
  {:vote => 1},
].each do |v|
  Vote.create!(:voter => User.first, :votable => Brand.first, :score => v[:vote])
end

# Brand Types
BrandType.delete_all
BrandType.find_by_sql('delete from sqlite_sequence where name = "brand_types"')
[
  'Men',
  'Women',
  'Kids',
  'Shoes',
  'Accessories'
].each do |bt|
  BrandType.create!(:name => bt)
end