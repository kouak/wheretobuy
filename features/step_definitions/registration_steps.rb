Given /"([^\"]*)" is an anonymous user/ do |email|
  Given "I go to the logout page"
end

Given /^"([^\"]*)" an unconfirmed user with password "([^\"]*)"$/ do |email, password|
  Given "\"#{email}\" is an anonymous user"
  When "I go to the registration page"
  Then "I should see the registration form"
  And "I fill in \"email\" with \"#{email}\""
  And "I fill in \"password\" with \"#{password}\""
  And "I fill in \"password confirmation\" with \"#{password}\""
  And "I press \"Sign up\""
  Then "I should have a successful registration"
end

Given /^"([^\"]*)" a notified but unconfirmed user with password "([^\"]*)"$/ do |email, password|
  Given "\"#{email}\" an unconfirmed user with password \"#{password}\""
  Then "\"#{email}\" should receive an account confirmation email"
end

Given /^"([^\"]*)" a confirmed user with password "([^\"]*)"$/ do |email, password|
  Given "\"#{email}\" a notified but unconfirmed user with password \"#{password}\""
  When "I follow \"Confirm my account\" in the email"
  Then "I should have a successful activation"
  And "a clear email queue"
  When "I follow \"Sign out\""
  Then "I should be logged out"
end

Given /^"([^\"]*)" a confirmed user with email "([^\"]*)"$/ do |name, email|
  Given "\"#{name}\" is an anonymous user"
  When "I go to the registration form"
  And "I fill in \"login\" with \"#{name}\""
  And "I fill in \"email\" with \"#{email}\""
  And "I press \"Register\""
  Then "I should receive an email"
  When "I open the email"
  And "I follow \"activate your account\" in the email"
  And "I fill in \"set your password\" with \"secret\""
  And "I fill in \"password confirmation\" with \"secret\""
  And "I press \"Activate\""
  Then "I should have a successful activation"
  And "a clear email queue"
  When "I follow \"Logout\""
  Then "I should be logged out"
end

Then /^I should see the registration form$/ do
  response.should contain('Email')
  response.should contain('Password')
  response.should contain('Password confirmation')
end

Then /^I should see the activation form$/ do
  response.should contain('Set your password')
  response.should contain('Password confirmation')
end

Then /^I should have a successful registration$/ do
  Then 'I should see "account has been created"'
end

Then /^I should have an unsuccessful registration$/ do
  Then 'I should not see "account has been created"'
end

Then /^I should have a successful activation$/ do
  Then 'I should see "Your account was successfully confirmed"'
end

Then /^I should have an unsuccessful activation$/ do
  Then 'I should not see "Your account was successfully confirmed"'
end

Then /^I should see the home page$/ do
  Then 'I should see "Home"'
end

Then /^I should see my account page$/ do
  Then 'I should be on the account page'
  And 'I should see "User Account"'
end

Then /^I should not see my account page$/ do
  Then 'I should not see "User Account"'
end

Then /^"([^\"]*)" should receive an account confirmation email$/ do |email|
  Then "\"#{email}\" should have an email"
  When "I open the email"
  Then "I should see \"Confirm my account\" in the email body"
end

Then /^I should see my account editing page$/ do
  Then 'I should be on the account editing page'
  And 'I should see "Editing user"'
end