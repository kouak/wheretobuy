class CitiesController < ApplicationController
  
  before_filter :get_country_if_nested

  def index
    @cities = @country.cities.all
  end
  
  def show
    @city = @country.cities.find(params[:id])
  end
  
  def new
    @city = City.new
  end
  
  def create
    @city = City.new(params[:city])
    @city.country = @country
    if @city.save
      flash[:notice] = "Successfully created city."
      redirect_to @city
    else
      render :action => 'new'
    end
  end
  
  def edit
    @city = @country.cities.find([:id])
  end
  
  def update
    @city = @country.cities.find(params[:id])
    if @city.update_attributes(params[:city])
      flash[:notice] = "Successfully updated city."
      redirect_to @city
    else
      render :action => 'edit'
    end
  end
  
  def autocomplete
    if params[:query].blank?
      q = '%'
    else
      q = params[:query] + '%'
    end
    
    if params[:country_id].blank?
      conditions = ['name LIKE ?', "#{q}"]
    else
      conditions = ['name LIKE ? AND country_id = ?', "#{q}", params[:country_id]]
    end
    
    @cities = City.find(:all, :conditions => conditions)
    respond_to do |format|
      format.html
      format.xml { render :xml => @cities }
      format.json { 
        a = {
          'query' => params[:query],
          'suggestions' => @cities.map do |c| c.name end
        }
        render :json => a.to_json
      }
    end
  end
  
  def destroy
    @city = City.find(params[:id])
    @city.destroy
    flash[:notice] = "Successfully destroyed city."
    redirect_to cities_url
  end
  
  private
  def get_country_if_nested
    @country = Country.find(params[:country_id]) unless params[:country_id].blank?
  end
end
