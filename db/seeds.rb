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
User.create!(:username => 'kouak', :email => 'benjamin.beret@gmail.com', :password => 'secret', :password_confirmation => 'secret', :sex => User::MALE).activate!
User.create!(:username => 'kouak2', :email => 'benjamin.beret2@gmail.com', :password => 'secret', :password_confirmation => 'secret', :sex => User::MALE).activate!

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

# Add some stuff to the wiki
if Brand.first.brand_wiki.nil?
  editor = User.first
  brand = Brand.first
  brand.create_brand_wiki(:editor_id => User.first.id, :version_comment => 'initial import', :bio => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit 
  anim id est laborum.').save!
  1.upto(3){|i| brand.brand_wiki.update_attributes!(:bio => brand.brand_wiki.bio + "\n\n Version #{i}", :version_comment => "v#{i}")}
end

# Votes
Vote.delete_all
[
  {:vote => 1},
].each do |v|
  Vote.create!(:voter => User.first, :votable => Brand.first, :score => v[:vote])
end