class FriendshipsController < ApplicationController
  
  before_filter :require_user
  before_filter :set_user
  
  def create
    @friendship = current_user.request_friendship_with(@user)
    if @friendship.save
      flash[:notice] = "Successfully requested friendship."
    else
      flash[:error] = "Couldn't request friendship :" + @friendship.errors.full_messages.join("<br />\n")
    end
    redirect_to user_url(@user)
  end
  
  def approve
    # Current_user approves a friendship requested by @user
    @friendship = @user.friendships.pending.with_friend(current_user).find(params[:id])
    @friendship.approve!
    flash[:notice] = "You're now friend with #{@user}"
    redirect_to user_url(@user)
  end
  
  def destroy
    # This function has 2 purposes :
    # 1. Current_user wants to cancel a request to @user
    # 2. Current_user wants to cancel his friendship with @user
    @friendship = current_user.friendships.with_friend(@user).find(params[:id])
    if @friendship.pending?
      flash[:notice] = "Successfully cancelled friend request with #{@user}"
    elsif @friendship.approved?
      flash[:notice] = "Successfully cancelled friendship with #{@user}"
    else
      # Should never happen
    end
    @friendship.destroy
    redirect_to user_url(@user)
  end
  
  private
  def set_user
    @user = User.find(params[:user_id])
  end
  
end
