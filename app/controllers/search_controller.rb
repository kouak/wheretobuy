class SearchController < ApplicationController
  
  before_filter :set_filter
  
  def index
    if params[:query].nil?
      redirect_to root_url
    else
      query = params[:query].to_s.strip
    end
    
    @search_results = {}
    
    @search_models.each do |model|
      @search_results[model.name.to_sym] = model.search(query)
    end
    
  end

  private
  def set_filter
    @search_models = []
    case params[:filter]
      when 'brands'
        @search_models = [Brand]
      when 'locations'
        @search_models = [City, Country]
      else
        @search_models = [Brand, City, Country]
    end
    
    @search_models = [Brand]
  end
end