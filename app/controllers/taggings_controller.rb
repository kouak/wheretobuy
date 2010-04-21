class TaggingsController < ApplicationController
  before_filter :require_user
  before_filter :find_parent
  
  def new
    @tag_list = parent.owner_tag_list_on(current_user, :tags)
  end
  
  def create
    if current_user.tag(parent, :with => (params[:tagging] && params[:tagging][:tag_list]) || '', :on => :tags)
      flash[:success] = 'Tagged successfully !'
      redirect_to_parent_tags_path
      return
    else
      render :new
    end
  end
  
  private
  def parent
    @parent ||= find_parent
  end
  
  def find_parent
    if params[:brand_id]
      @parent ||= Brand.find(params[:brand_id])
    else
      raise Error404
    end
  end
  
  def redirect_to_parent_tags_path
    redirect_to send(parent.class.to_s.downcase + '_tags_path', parent)
  end
end
