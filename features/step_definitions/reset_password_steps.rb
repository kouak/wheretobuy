Given /^"([^\"]*)" a user who opened (?:his|her) reset password email$/ do |email|
  Given "\"#{email}\" a confirmed user with password \"secret\""
  When "I go to the reset password page"
  And "I fill in \"email\" with \"#{email}\""
  And "I press \"Reset my password\""
  Then "\"#{email}\" should receive an email"
  When "I open the email"
  Then "I should see \"Change my password\" in the email body"
end

Then /^I (?:should )?see a reset password form$/ do
  response.should contain('Forgot Password')
  response.should contain('Email')
end

Then /^I (?:should )?see a password modification form$/ do
  response.should contain('Change my password')
  response.should contain('Password')
  response.should contain('Password confirmation')
end

Then /^I should not see a password modification form$/ do
  response.should_not contain('Change your password')
end