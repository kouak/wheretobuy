Feature: Password Reset
  As a user who forgot her password
  I want to reset my password
  So that I can continue using the site

  Scenario: Display a reset password form
    Given "abc@abc.com" is an anonymous user
    When I go to the reset password page
    Then I should see a reset password form

  Scenario: Send a reset instructions email if given a valid email
    Given "abc@abc.com" a confirmed user with password "secret"
    When I go to the reset password page
    And I fill in "email" with "abc@abc.com"
    And I press "Reset my password"
    Then I should receive an email
    When I open the email
    And I should see "Change my password" in the email body

  Scenario: Do not send a reset instructions email if given an invalid email
    Given "abc@abc.com" a confirmed user with password "secret"
    When I go to the reset password page
    And I fill in "email" with "unknown@example.com"
    And I press "Reset my password"
    Then "abc@abc.com" should receive no emails
    And "unknown@example.com" should receive no emails
    And I should see "This user does not exist"

  Scenario: Display change password form with valid token
    Given "abc@abc.com" a user who opened her reset password email
    When I follow "Change my password" in the email
    Then I should see a password modification form

  Scenario: Refuse change password form with invalid token
    Given "abc@abc.com" a user who opened her reset password email
    When I go to the change password form with bad token
    Then I should see "we could not locate your account"

  Scenario: Update password and log in user with valid input
    Given "abc@abc.com" a user who opened her reset password email
    When I follow "Change my password" in the email
    Then I should see a password modification form
    When I fill in "password" with "new secret"
    And I fill in "Password confirmation" with "new secret"
    And I press "Change my password"
    Then I should see the home page
    And I should see "Password successfully updated"
    When I follow "Sign out"
    Then I should be logged out
    When I go to the home page
    And I follow "Sign in"
    And I fill in "email" with "abc@abc.com"
    And I fill in "password" with "new secret"
    And I press "Sign in"
    Then I should be logged in

  Scenario Outline: Do not update password and log in user with invalid input
    Given "abc@abc.com" a user who opened her reset password email
    When I follow "Change my password" in the email
    Then I should see a password modification form
    When I fill in "password" with "<password>"
    And I fill in "Password confirmation" with "<confirmation>"
    And I press "Change my password"
    Then I should see a password modification form
    And I should see "<error_message>"
    And I should not see "Password successfully updated"

    Examples:
      | password   | confirmation | error_message                       |
      |            |              | Password is too short               |
      |            | new secret   | Password is too short               |
      | new secret |              | Password doesn't match confirmation |
      | new secret | secret       | Password doesn't match confirmation |
  
  Scenario: Do not allow a logged in user to reset his password
    Given "abc@abc.com" a logged in user with password "secret"
    When I go to the reset password page
    Then I should see "You must be logged out"