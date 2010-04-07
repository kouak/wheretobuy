class ActionController::TestCase
  def self.should_be_denied(opts = {})
    should_set_the_flash_to(opts[:flash] || /must be logged in/i)
    should_redirect_to("the denied page") { send(opts[:redirect] || 'login_path') }   
  end
  
  def self.should_redirect_to_home
    should_redirect_to("the home page") { root_path }   
  end
end