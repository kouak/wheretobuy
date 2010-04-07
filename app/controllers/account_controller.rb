class AccountController < ApplicationController
  
  before_filter :require_user, :except => [:new, :create]
  before_filter :require_no_user, :only => [:new, :create]

  layout :smart_layout
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save_without_session_maintenance
      @user.deliver_activation_instructions!
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
      redirect_to root_url
    else
      render :action => :new
    end
  end

  def show # Dashboard style stuff
    @user = current_user
  end

  def edit # Edit my own account
    @user = current_user
  end
  
  def update # Update my own account
    @user = current_user
    @user.validates_password_change = true # only allow password change provided a current valid password
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
  
  def destroy
    current_user.destroy
    flash[:notice] = "Your account has been deleted. We hope to see you again soon !"
    redirect_to root_url
  end
  
  def friends
    @user = current_user
    @pending_friendships = current_user.friendships.pending
    @requested_friendships = current_user.reverse_friendships.pending
    @friendships = current_user.friendships.approved
    @selected_tab = "My Friends"
  end

  private
  def smart_layout
    layouts_for_actions = {
      :new => 'application',
      :create => 'application'
    }
    default_layout = 'account'
    layouts_for_actions.fetch(action_name.to_sym, default_layout)
  end
  
end