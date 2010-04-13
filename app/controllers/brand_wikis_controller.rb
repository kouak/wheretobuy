class BrandWikisController < ApplicationController
  
  before_filter :require_user, :only => [:edit, :update, :destroy]
  before_filter :set_brand
  
  before_filter :find_brand_wiki_or_redirect, :only => [:show, :diff, :history]
  
  layout :set_layout, :only => [:show, :edit, :history, :diff]
  
  def show # See extended informations
    @last_version = @brand.brand_wiki.version
  end
  
  def edit # Edit
    @brand_wiki = @brand.brand_wiki || BrandWiki.new
    @brand_wiki = @brand_wiki.find_version(params[:version].to_i) if params[:version]
  end
  
  def history # show history of updates
    @versions = @brand.brand_wiki.history.paginate(:page => params[:page], :per_page => 10)
  end
  
  def diff # show differences between versions
    v1 = params[:v1].to_i
    v2 = params[:v2].to_i == 0 ? :last : params[:v2].to_i
    @changes = @brand_wiki.differences_between(v1, v2)
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
  
  def find_brand_wiki_or_redirect
    if @brand.brand_wiki.nil?
      flash[:notice] = "This brand does not have information yet. Feel free to contribute !"
      redirect_to edit_brand_brand_wiki_path(@brand)
      return false # prevents action from being triggered
    else
      @brand_wiki = @brand.brand_wiki
      @brand_wiki = @brand.brand_wiki.find_version(params[:version]) if params[:version]
      return true
    end
  end
  
  def set_layout
    @selected_tab = 'Wiki'
    'brand_profile'
  end
end
