class FriendshipsController < ApplicationController
  def index
    @friendships = Friendship.all
  end
  
  def show
    @friendship = Friendship.find(params[:id])
  end
  
  def new
    @friendship = Friendship.new
  end
  
  def create
    @friendship = Friendship.new(params[:friendship])
    if @friendship.save
      flash[:notice] = "Successfully created friendship."
      redirect_to @friendship
    else
      render :action => 'new'
    end
  end
  
  def edit
    @friendship = Friendship.find(params[:id])
  end
  
  def update
    @friendship = Friendship.find(params[:id])
    if @friendship.update_attributes(params[:friendship])
      flash[:notice] = "Successfully updated friendship."
      redirect_to @friendship
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy
    flash[:notice] = "Successfully destroyed friendship."
    redirect_to friendships_url
  end
end
