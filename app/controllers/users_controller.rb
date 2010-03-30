class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :reset_password]
  before_filter :require_user, :only => [:account, :edit, :update]

  layout :smart_layout
  
  def new
    @user = User.new
  end
  
  def index
    @users = User.all
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
  
  def account
    @user = current_user
  end

  def show
    @user = User.find(params[:id])
    @comments = @user.comments.all(:limit => 5)
  end
  
  def friends
    @user = User.find(params[:id], :include => :friends)
  end
  
  def favorite_brands
    @user = User.find(params[:user_id])
    @favorite_brands = @user.sent_votes.descending.positive_score.for_votable_class(Brand).paginate(:page => params[:page], :per_page => 2)
    @selected_tab = 'Favorite brands'
  end
  
  def comments
    @user = User.find(params[:user_id])
    @comments = @user.comments.paginate(:page => params[:page], :per_page => 2)
    @selected_tab = 'Comments'
  end

  def edit
    @user = current_user
  end
  
  def reset_password
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = "Password successfully updated"
      redirect_to account_url
    else
      render :controller => :password_resets, :action => :edit
    end
  end

  def update
    @user = current_user
    @user.validates_password_change = true # only allow password change provided a current valid password
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
  
  def smart_layout
    profile_actions = [:show, :friends, :favorite_brands, :comments]
    profile_actions.include?(action_name.to_sym) ? 'user_profile' : 'application'
  end
  
end