class StaticPagesController < ApplicationController
  def home
    @users = User.all
    @brands = Brand.featured
  end
end
