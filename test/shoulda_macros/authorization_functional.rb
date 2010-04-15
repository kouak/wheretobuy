class ActionController::TestCase
  
  def login_as(user = :active_user)
    activate_authlogic
    UserSession.stubs(:find).returns(user_session)
    user_session.stubs(:user).returns(current_user)
  end
  
  def current_user(stubs = {})
    @current_user ||= Factory.stub(:active_user)
  end

  def user_session
    @current_user_session ||= Factory.stub(:user_session)
  end

  def login(session_stubs = {}, user_stubs = {})
    activate_authlogic
    
    user_session.stubs(:user).returns(current_user)
  end

  def logout
    @user_session = nil
  end
  
  def self.should_be_denied(opts = {})
    should_set_the_flash_to(opts[:flash] || /must be logged in/i)
    should_redirect_to("the denied page") { send(opts[:redirect] || 'login_path') }   
  end
  
  def self.should_redirect_to_home
    should_redirect_to("the home page") { root_path }   
  end
end