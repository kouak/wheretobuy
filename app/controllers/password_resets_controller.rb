class PasswordResetsController < ApplicationController
  
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  
  def new
  end
  
  def create
    @user = User.find_by_email(params[:password_resets][:email])
    if @user.nil? or !@user.active?
      flash[:error] = "This user does not exist or has not been activated yet"
      redirect_to root_url
      return
    end
    
    @user.deliver_password_reset_instructions!
    flash[:notice] = "Instructions to reset your password have been emailed to you. " +
      "Please check your email."
    redirect_to root_url
  end
  
  def edit
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.validate_password = 1
    if @user.save
      flash[:notice] = "Password successfully updated"
      UserSession.create(@user, true).save # Logs in the user and set cookie
      redirect_to account_url
    else
      render :action => :edit, :token => params[:token]
    end
  end

  private
    def load_user_using_perishable_token
      @user = User.find_using_perishable_token(params[:token])
      # This is a special method that Authlogic gives you. Here is what it does for extra security:
      #  * Ignores blank tokens
      #  * Only finds records that match the token and have an updated_at (if present) value that is not older than 10 minutes.
      #    This way, if someone gets the data in your database any valid perishable tokens will expire in 10 minutes.
      #    Chances are they will expire quicker because the token is changing during user activity as well.
      unless @user
        flash[:notice] = "We're sorry, but we could not locate your account." +
          "If you are having issues try copying and pasting the URL " +
          "from your email into your browser or restarting the " +
          "reset password process."
        redirect_to root_url
      end
    end
end