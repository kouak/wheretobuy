class BrandWikisController < ApplicationController
  
  before_filter :require_user, :only => [:edit, :update, :destroy]
  before_filter :set_brand
  
  def show # See extended informations
    @brand_wiki = @brand.brand_wiki
    if @brand_wiki.nil?
      flash[:warning] = "This brand does not have information yet."
      redirect_to @brand.nil? ? home : @brand
    end
  end
  
  def edit # Edit 
    @brand_wiki = @brand.brand_wiki || BrandWiki.new
  end
  
  def history # show history of updates
    @versions = @brand.brand_wiki.versions.reverse
  end
  
  def diff # show differences between versions
    
  end
  
  def update
    params[:brand_wiki][:brand_id] = @brand.id # Parent override
    
    if @brand.brand_wiki.nil? # Set @brand_wiki and params
      @brand_wiki = BrandWiki.new(params[:brand_wiki])
    else
      @brand_wiki = @brand.brand_wiki
      @brand_wiki.attributes = params[:brand_wiki]
    end
    
    @brand_wiki.updated_by = current_user # vestal_versions editor
    
    if @brand_wiki.save # And save
      flash[:notice] = "Successfully edited brand wiki."
      redirect_to @brand
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @brand_wiki = @brand.brand_wiki
    @brand_wiki.destroy
    flash[:notice] = "Successfully destroyed brand wiki."
    redirect_to brand_wikis_url
  end
  
  private
  def set_brand
    @brand = Brand.find(params[:brand_id]) or redirect_to home
  end
end
