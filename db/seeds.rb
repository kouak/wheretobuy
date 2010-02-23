# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

require 'open-uri'

User.delete_all
User.create!(:email => 'benjamin.beret@gmail.com', :password => 'secret', :password_confirmation => 'secret').activate!

Country.delete_all
open("http://openconcept.ca/sites/openconcept.ca/files/country_code_drupal_0.txt") do |countries|
  countries.read.each_line do |country|
    code, name = country.chomp.split("|")
    Country.create!(:name => name)
  end
end

City.delete_all
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
  {:id => 1, :name => 'A.P.C', :url => 'http://www.apc.fr/'},
  {:id => 2, :name => 'Rick Owens'}
].each do |b|
  Brand.create!(b)
end

Vote.delete_all
[
  {:vote => 1},
].each do |v|
  Vote.create!(:voter => User.first, :votable => Brand.first, :score => v[:vote])
end