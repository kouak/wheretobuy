Feature: Registration
  In order to get my personal account
  As a anonymous user
  I want be able to register
  So that I can be a member of the community

  Scenario: Display registration form to anonymous user
    Given "abc@abc.com" is an anonymous user
    When I go to the homepage
    Then I should see "Sign up"
    When I follow "Sign up"
    Then I should see the registration form

  Scenario: Allow an anonymous user to create account
    Given "abc@abc.com" is an anonymous user
    When I go to the registration form
    And I fill in "username" with "abc"
    And I fill in "email" with "abc@abc.com"
    And I fill in "password" with "secret"
    And I fill in "password confirmation" with "secret"
    And I press "Sign up"
    Then I should have a successful registration

  Scenario Outline: Not allow an anonymous user to create account with incomplete input
    Given "abc@abc.com" is an anonymous user
    When I go to the registration form
    And I fill in "username" with "<username>"
    And I fill in "email" with "<email>"
    And I fill in "password" with "<password>"
    And I fill in "password confirmation" with "<password confirmation>"
    And I press "Sign up"
    Then I should have an unsuccessful registration
    And I should see "<error_message>"

    Examples: incomplete registration inputs
      | username | email   | password | password confirmation  | error_message                        |
      | abc      |         |          |                        | Email should look like an email      |
      |          |         |          |                        | Username is too short                |
      | abc      | blabla  |          |                        | Email should look like an email      |
      | abc      | a@a.com |          |                        | Password is too short                |
      | abc      | a@a.com |          | secret                 | Password is too short                |
      | abc      | a@a.com | secret   | new secret             | Password doesn't match confirmation  |
      | abc      | a@a.com | secret   | new secret             | Password doesn't match confirmation  |

    
  Scenario: Send an activation instruction mail at a successful account creation
    Given "abc@abc.com" a notified but unconfirmed user with password "secret"
    And "abc@abc.com" should receive an email
    When I open the email
    Then I should see "Confirm my account" in the email body

  Scenario: Want to confirm account using mail activation token
    Given "abc@abc.com" a notified but unconfirmed user with password "secret"
    When "abc@abc.com" open the email
    And I follow "Confirm my account" in the email
    Then I should see "Your account was successfully confirmed"
    And I should be logged in

  Scenario: Do not confirm an account with invalid mail activation token
    Given "abc@abc.com" an unconfirmed user with password "secret"
    When I go to the confirm page with bad token
    Then I should see "Invalid activation code"
    
  Scenario: Activate account using mail activation token
    Given "abc@abc.com" a notified but unconfirmed user with password "secret"
    When "abc@abc.com" open the email
    And I follow "Confirm my account" in the email
    Then I should have a successful activation
    And I should be logged in
    When I follow "Sign out"
    Then I should be logged out

  Scenario: Resend confirmation instructions
    Given "abc@abc.com" a notified but unconfirmed user with password "secret"
    Given a clear email queue
    When I go to the resend confirmation page
    And I fill in "email" with "abc@abc.com"
    And I press "Resend confirmation instructions"
    Then I should see "have been sent"
    And "abc@abc.com" should receive an email
    When I open the email
    And I follow "Confirm my account" in the email
    Then I should have a successful activation
    And I should be logged in
    
  Scenario: Do not resend confirmation for confirmed account
    Given "abc@abc.com" a confirmed user with password "secret"
    When I go to the resend confirmation page
    And I fill in "email" with "abc@abc.com"
    And I press "Resend confirmation instructions"
    Then "abc@abc.com" should receive no emails
    And I should see "already active"
    
  Scenario: Not allow access to resend form as logged in user
    Given "abc@abc.com" a logged in user with password "secret"
    When I go to the resend confirmation page
    Then I should see "You must be logged out"