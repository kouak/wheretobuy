class ActivationsController < ApplicationController
  before_filter :require_no_user
  
  def new
    render
  end
  
  def create
    @user = User.find_by_email(params[:activation] && params[:activation][:email])
    
    
    if @user.nil? or @user.active?
      flash[:error] = "This account does not exist or is already active !"
      redirect_to :action => :new
      return
    end
    
    @user.deliver_activation_instructions!
    flash[:notice] = "Your account activation instructions have been sent !"
    redirect_to root_url

  end
  
  
  def activate
    @user = User.find_using_perishable_token(params[:activation_code], 1.week)

    if @user.nil? || @user.active?
      flash[:error] = "Invalid activation code"
      redirect_to root_url
    else
      @user.activate!
      @user.deliver_activation_confirmation!
      flash[:notice] = "Your account was successfully confirmed" + "You can now fill in your information"
      UserSession.create(@user, true) # Logs in the user and set cookie
      redirect_to edit_account_url
    end
  end

end