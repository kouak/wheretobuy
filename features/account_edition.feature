Feature: Password Reset
  As a registered user
  I want to edit my account informations
  So that my account informations reflects the reality
  
  Scenario: Display account information
    Given "abc@abc.com" a logged in user with password "secret"
    When I go to the home page
    Then I should see "My account"
    And I follow "My account"
    Then I should be on the account page
    
  Scenario: Do not display account information to anonymous users
    Given "anonymous" is an anonymous user
    When I go to the account page
    Then I should see "You must be logged in"
    
  Scenario: Allow logged in users to change their password
    Given "abc@abc.com" a logged in user with password "secret"
    When I go to the account edit page
    And I fill in "Current password" with "secret"
    And I fill in "password" with "new secret"
    And I fill in "password confirmation" with "new secret"
    And I press "Submit"
    Then I should see "Account updated"
    When I follow "Sign out"
    Then I should be logged out
    When I follow "Sign in"
    And I fill in "email" with "abc@abc.com"
    And I fill in "password" with "new secret"
    And I press "Sign in"
    Then I should be logged in
    
  Scenario: Allow logged in users to change their information leaving the password untouched
    Given "abc@abc.com" a logged in user with password "secret"
    When I go to the account edit page
    And I fill in "username" with "abc"
    And I press "Submit"
    Then I should see "Account updated"
    And I should see "abc"
    When I follow "Sign out"
    Then I should be logged out
    When I follow "Sign in"
    And I fill in "email" with "abc@abc.com"
    And I fill in "password" with "secret"
    And I press "Sign in"
    Then I should be logged in
  
  Scenario Outline: Not allow logged in users to change their password without providing their correct current password
    Given "abc@abc.com" a logged in user with password "secret"
    When I go to the account edit page
    And I fill in "Current password" with "<current>"
    And I fill in "password" with "<new>"
    And I fill in "password confirmation" with "<new_c>"
    And I press "Submit"
    Then I should see "<error_message>"
    
    Examples:                      
      | current       | new        | new_c      | error_message                           |
      |               | secret     |            | Current password does not match         |
      |               |            | bad secret | Current password does not match         |
      | wrongsecret   |            |            | Current password does not match         |
      | wrongsecret   | secret     | secret     | Current password does not match         |
      | secret        | new secret | bad secret | doesn't match confirmation              |
      | secret        | new secret |            | doesn't match confirmation              |
      | secret        |            |            | Account updated                         |
  