class UsersController < ApplicationController
  before_filter :find_user, :except => [:index]
  before_filter :redirect_to_correct_slug, :only => :show
  
  layout :smart_layout
  
  def index
    @users = User.all
  end
  
  def show
    @comments = @user.comments.all(:limit => 5)
  end

  def friends
    @friendships = @user.approved_friendships.paginate(:page => params[:page], :per_page => 2)
  end
  
  def favorite_brands
    @favorite_brands = @user.sent_votes.descending.positive_score.for_votable_class(Brand).paginate(:page => params[:page], :per_page => 2)
    @selected_tab = 'Favorite brands'
  end
  
  def comments
    @comments = @user.comments.paginate(:page => params[:page], :per_page => 2)
    @selected_tab = 'Comments'
  end
  
  private
  def find_user
    @user = User.find(params[:user_id] || params[:id]) or redirect_to home # 404 error ?!
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