class BrandWikisController < ApplicationController
  
  before_filter :require_user, :only => [:edit, :update, :destroy]
  before_filter :set_brand
  
  def show # See extended informations
    @brand_wiki = @brand.brand_wiki
    @last_version = @brand_wiki.version
    @brand_wiki.revert_to(params[:version].to_i) if params[:version]
    if @brand_wiki.nil?
      flash[:warning] = "This brand does not have information yet."
      redirect_to @brand.nil? ? home : @brand
    end
  end
  
  def edit # Edit 
    @brand_wiki = @brand.brand_wiki || BrandWiki.new
    @brand_wiki.revert_to(params[:version].to_i) if params[:version]
  end
  
  def history # show history of updates
    @brand_wiki = @brand.brand_wiki
    @versions = @brand.brand_wiki.history
  end
  
  def diff # show differences between versions
    v1 = params[:v1].to_i == 0 ? :last : params[:v1].to_i
    v2 = params[:v2].to_i == 0 ? :first : params[:v2].to_i
    @changes = @brand.brand_wiki.differences_between(v1, v2)
  end
  
  def update
    params[:brand_wiki][:brand_id] = @brand.id # Parent override
    params[:brand_wiki][:editor_id] = current_user.id # Editor id
    if @brand.brand_wiki.nil? # Set @brand_wiki and params
      @brand_wiki = BrandWiki.new(params[:brand_wiki])
    else
      @brand_wiki = @brand.brand_wiki
      @brand_wiki.attributes = params[:brand_wiki]
    end
    
    @brand_wiki.updated_by = current_user # vestal_versions editor (actually we don't care about it since we have our own editor_id)
    
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
