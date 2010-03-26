class CommentsController < ApplicationController
  
  before_filter :set_commentable_or_redirect
  
  layout :set_layout
  
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
      redirect_to @commentable
    else
      # TODO : Ajax
      flash[:error] = @comment.errors.full_messages.to_s
      redirect_to @commentable
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
    
    case @commentable
    when Brand
      @brand = @commentable
    end
  end
  
  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
  
  def set_layout
    'application'
  end
  
  def set_paginated_comments
    @comments = @commentable.try(:comments).paginate(:page => params[:page], :per_page => 2)
  end
end
