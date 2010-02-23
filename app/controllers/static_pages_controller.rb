class StaticPagesController < ApplicationController
  def home
    @users = User.all
    @brands = Brand.featured
    @cities = City.featured
  end
end
