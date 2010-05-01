class UsersController < ApplicationController
  before_filter :find_user, :except => [:index]
  before_filter :redirect_to_correct_slug, :only => :show
  
  layout :smart_layout
  
  def index
    @users = User.all
  end
  
  def show
    @comments = @user.comments.all(:limit => 5)
    @activities = Activity.recent.regarding_user(@user).find(:all, :limit => 8)
  end

  def friends
    @friendships = @user.approved_friendships.paginate(:page => params[:page], :per_page => 2)
  end
  
  def favorite_brands
    @favorite_brands = @user.sent_votes.for_votable_class(Brand).descending.positive_score.paginate(:page => params[:page], :per_page => 2)
    @selected_tab = 'Favorite brands'
  end
  
  def comments
    @comments = @user.comments.paginate(:page => params[:page], :per_page => 2)
    @selected_tab = 'Comments'
  end
  
  def activity
    @activities = Activity.recent.regarding_user(@user).find(:all, :limit => (params[:page] || 1).to_i * 15)
    @selected_tab = 'Activity'
  end
  
  private
  def find_user
    @user = User.find(params[:user_id] || params[:id]) # no user will raise ActiveRecord::RecordNotFound which is caught and rendered as 404
  end
  
  def redirect_to_correct_slug
    redirect_to @user unless @user.to_param == params[:id]
  end
  
  def smart_layout
    layouts_for_actions = {
      :index => 'application'
    }
    default_layout = 'user_profile'
    layouts_for_actions.fetch(action_name.to_sym, default_layout)
  end
  
end