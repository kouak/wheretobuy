class CommentsController < ApplicationController
  
  before_filter :require_user, :only => [:new, :create, :update, :destroy, :edit]
  
  def index
    # This action should be defined in commentable controllers
    raise Error404
  end
  
  def show
    @comment = Comment.find(params[:id])
  end
  
  def new
    @comment = parent.comments.new
    @commentable = parent
  end
  
  def create
    @comment = parent.comments.new(params[:comment])
    @comment.author = current_user
    if @comment.save
      flash[:success] = "Successfully created comment"
      redirect_to @comment.resource
    else
      @commentable = parent
      render :action => 'new'
    end
  end
  
  def edit
    @comment = Comment.find(params[:id])
  end
  
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:success] = "Successfully updated comment"
      redirect_to @comment
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    commentable = @comment.resource
    @comment.destroy
    flash[:success] = "Successfully destroyed comment"
    redirect_to polymorphic_path([commentable, :comments])
  end
  
  private
  
  def parent
    if params[:brand_id]
      @parent ||= Brand.find(params[:brand_id])
    elsif params[:user_id]
      @parent ||= User.find(params[:user_id])
    else
      raise Error404
    end
  end
end
