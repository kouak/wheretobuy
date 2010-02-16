class CommentsController < ApplicationController
  
  before_filter :set_commentable_or_redirect
  
  def index
    set_paginated_comments
  end
  
  def show
    @comment = Comment.find(params[:id])
  end
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.author = current_user
    @commentable.comments << @comment
    if @comment.save
      flash[:notice] = "Successfully created comment."
      redirect_to polymorphic_url([@commentable, :comments])
    else
      set_paginated_comments
      render 'index'
    end
  end
  
  def edit
    @comment = Comment.find(params[:id])
  end
  
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Successfully updated comment."
      redirect_to polymorphic_url([@commentable, @comment])
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    redirect_to polymorphic_path([@commentable, :comments])
  end
  
  
  private
  def set_commentable_or_redirect
    @commentable = find_commentable
    redirect_to home if @commentable.nil?
  end
  
  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
  
  def set_paginated_comments
    @comments = @commentable.try(:comments).paginate(:page => params[:page], :per_page => 2)
  end
end
