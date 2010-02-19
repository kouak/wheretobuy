# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

require 'open-uri'

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