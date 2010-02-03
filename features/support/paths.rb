module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the home\s?page/
      '/'
    
    when /the login page/
      '/users/sign_in'
    
    when /the registration page/
      new_user_path
      
    when /(?:the|my) account page/
      account_path
      
    when /(?:the|my) account edit(ing)? page/
      edit_account_path
    
    
    when /the logout page/
      '/users/sign_out'
      
    when /the reset password page/
      new_password_resets_path
      
    when /the change password form with bad token/
      edit_password_resets_path('blabla')
      
    when /the confirm page with bad token/
      activate_path('blablablabla')
      
    when /the registration form/
      new_user_path
    
    when /the resend confirmation page/
      new_activation_path
    
    
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
