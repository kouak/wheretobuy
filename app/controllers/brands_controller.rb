class BrandsController < ApplicationController
  
  after_filter :increment_pageviews, :only => [:show]
  
  before_filter :require_user, :only => [:new, :create, :update, :destroy, :edit]
  
  layout :smart_layout
  
  
  PER_PAGE = 5
  
  def index
    @brands = Brand.paginate(:page => params[:page], :per_page => PER_PAGE)
  end
  
  def show
    @brand = Brand.find(params[:id], :include => [:votes, :brand_wiki])
    @comments = @brand.comments.find(:all, :limit => 10)
    @tags = @brand.tag_counts_on(:tags)
  end
  
  def comments
    @brand = Brand.find(params[:brand_id])
    @comments = @brand.comments.paginate(:page => params[:page], :per_page => 2)
    @selected_tab = 'Comments'
  end
  
  def fans
    @brand = Brand.find(params[:brand_id])
    @votes = @brand.votes.positive_score.descending.paginate(:page => params[:page], :per_page => 4)
  end
  
  def new
    @brand = Brand.new
  end
  
  def create
    @brand = Brand.new(params[:brand])
    if @brand.save
      flash[:notice] = "Successfully created brand."
      redirect_to @brand
    else
      render :action => 'new'
    end
  end
  
  def edit
    @brand = Brand.find(params[:id])
  end
  
  def update
    @brand = Brand.find(params[:id])
    if @brand.update_attributes(params[:brand])
      flash[:notice] = "Successfully updated brand."
      redirect_to @brand
    else
      render :action => 'edit'
    end
  end
  
  def search
    if params[:q].nil? || params[:q].size == 0
      redirect_to brands_url
    end
    
    @brands = Brand.search(params[:q].to_s)
    
  end
  
  def destroy
    @brand = Brand.find(params[:id])
    @brand.destroy
    flash[:notice] = "Successfully destroyed brand."
    redirect_to brands_url
  end
  
  private
  def smart_layout
    profile_actions = [:show, :fans, :comments]
    profile_actions.include?(action_name.to_sym) ? 'brand_profile' : 'application'
  end
  
  def increment_pageviews
    @brand.increment_pageviews
    @brand.save!
  end
end
