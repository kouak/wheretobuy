
Given /^"(.*)" a logged in user with password "([^\"]*?)"$/ do |email, password|
  user = Factory.create(:user, :username => email.split('@').first, :email => email, :password => password, :password_confirmation => password)
  user.activate!
  
  visit user_session_path,
          :post,
          :user_session => {:email => email, :password => password}
  
  Then "I should be logged in"

#  Given "\"#{email}\" a confirmed user with password \"secret\""
#  When "I go to the login page"
#  And "I fill in \"email\" with \"#{email}\""
#  And "I fill in \"password\" with \"#{password}\""
#  And "I press \"Sign in\""
#  Then "I should be logged in"
end

Given /^I should see a login form$/ do
  response.should contain("Email")
  response.should contain("Password")
  response.should contain("Remember me")
end

When /^I open the homepage in a new window with cookies$/ do
  in_a_separate_session do
    visit root_path
    response.should contain("Sign out")
  end
  response.should contain("Sign out")
end

When /^I open the homepage in a new window without cookies$/ do
  in_a_new_session do |sess|
    visit root_path
    response.should_not contain("Sign out")
  end
  response.should contain("Sign out")
end

Then /^I should be logged in$/ do
  Then 'I should see "Sign out"'
end

Then /^I should not be logged in$/ do
  Then 'I should not see "Sign out"'
end

Then /^I should be logged out$/ do
  Then 'I should not be logged in'
  And 'I should see "Logout successful"'
end