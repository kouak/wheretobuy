class BrandTypesController < ApplicationController
  def index
    @brand_types = BrandType.all
  end
  
  def show
    @brand_type = BrandType.find(params[:id])
  end
  
  def new
    @brand_type = BrandType.new
  end
  
  def create
    @brand_type = BrandType.new(params[:brand_type])
    if @brand_type.save
      flash[:notice] = "Successfully created brand type."
      redirect_to @brand_type
    else
      render :action => 'new'
    end
  end
  
  def edit
    @brand_type = BrandType.find(params[:id])
  end
  
  def update
    @brand_type = BrandType.find(params[:id])
    if @brand_type.update_attributes(params[:brand_type])
      flash[:notice] = "Successfully updated brand type."
      redirect_to @brand_type
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @brand_type = BrandType.find(params[:id])
    @brand_type.destroy
    flash[:notice] = "Successfully destroyed brand type."
    redirect_to brand_type_url
  end
end
