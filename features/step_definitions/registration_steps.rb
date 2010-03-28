Given /"([^\"]*)" is an anonymous user/ do |email|
  Given "I go to the logout page"
end

Given /^"([^\"]*)" an unconfirmed user with password "([^\"]*)"$/ do |email, password|
  @user = User.new(:username => 'abc', :email => email, :password => password, :password_confirmation => password)
  @user.save_without_session_maintenance
end

Given /^"([^\"]*)" a notified but unconfirmed user with password "([^\"]*)"$/ do |email, password|
  Given "\"#{email}\" an unconfirmed user with password \"#{password}\""
  @user.deliver_activation_instructions!
end

Given /^"([^\"]*)" a confirmed user with password "([^\"]*)"$/ do |email, password|
  Given "\"#{email}\" an unconfirmed user with password \"#{password}\""
  @user.activate!
end

Then /^I should see the registration form$/ do
  response.should contain('Email')
  response.should contain('Password')
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
  Then 'I should be on the home page'
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