Feature: Authentication
  As a confirmed but anonymous user
  I want to login to the application
  So that I can be productive

  Scenario: Display login form to anonymous users
    Given "abc@abc.com" is an anonymous user
    When I go to the login page
    Then I should see a login form

  Scenario: Allow login of a user with valid credentials
    Given "abc@abc.com" a logged in user with password "secret"
    When I follow "Sign out"
    Then I should be logged out

  Scenario Outline: Not allow login of a user with bad credentials
    Given "abc@abc.com" a confirmed user with password "secret"
    When I go to the login page
    And I fill in "email" with "<login>"
    And I fill in "password" with "<password>"
    And I press "Sign in"
    Then I should not be logged in
    And I should see "<error_message>"

    Examples:
      | login         | password   | error_message                           |
      |               |            | provide any details for authentication  |
      |               |  secret    | Email cannot be blank                   |
      |               | bad secret | Email cannot be blank                   |
      | unknown       |            | Password cannot be blank                |
      | unknown       |  secret    | is not valid                            |
      | unknown       | bad secret | is not valid                            |
      | abc@abc.com   |            | Password cannot be blank                |
      | abc@abc.com   | bad secret | is not valid                            |
      
  Scenario: Not allow unconfirmed users to login
    Given "abc@abc.com" an unconfirmed user with password "secret"
    When I go to the login page
    And I fill in "email" with "abc@abc.com"
    And I fill in "password" with "secret"
    And I press "Sign in"
    Then I should see "Your account is not active"
    And I should not be logged in
    
  Scenario: Not remember a user who does not wish to be remembered
    Given "abc@abc.com" a confirmed user with password "secret"
    When I go to the login page
    And I fill in "email" with "abc@abc.com"
    And I fill in "password" with "secret"
    And I uncheck "Remember me"
    And I press "Sign in"
    Then I should be logged in
    When I follow "Sign out"
    Then I should be logged out
    When I go to the home page
    Then I should not be logged in

  Scenario: Allow a confirmed user to login and be remembered
    Given "abc@abc.com" a confirmed user with password "secret"
    When I go to the login page
    And I fill in "email" with "abc@abc.com"
    And I fill in "password" with "secret"
    And I check "Remember me"
    And I press "Sign in"
    Then I should be logged in
    When I open the homepage in a new window with cookies
    Then I should be logged in
    When I follow "Sign out"
    Then I should be logged out
