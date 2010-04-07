class FriendshipsController < ApplicationController
  
  before_filter :set_user_or_redirect
  before_filter :require_user
  
  
  def create
    @friendship = current_user.request_friendship_with(@user)
    if @friendship.save
      flash[:notice] = "Successfully created friendship."
    else
      puts @friendship.errors.to_yaml
      flash[:error] = "Something wrong happened"
    end
    redirect_to @user
  end
  
  def approve
    
  end
  
  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy
    flash[:notice] = "Successfully destroyed friendship."
    redirect_to friendships_url
  end
  
  private
  def set_user_or_redirect
    @user = User.find(params[:user_id])
    redirect_to home if @user.nil?
  end
  
  
end
