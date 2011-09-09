Feature: Manage users
  In order to [goal]
  [stakeholder]
  wants [behaviour]

  Scenario Outline: Creating a new account
      Given I am not authenticated
      When I go to register # define this path mapping in features/support/paths.rb, usually as '/users/sign_up'
      And I fill in "user_email" with "<email>"
      And I fill in "user_password" with "<password>"
      And I fill in "user_password_confirmation" with "<password>"
      And I press "user_submit"
      # Then I should see "Signed in successfully." # should be work ?!
      Then I should see "New person"

      Examples:
        | email           | password   |
        | testing@man.net | secretpass |
        | foo@bar.com     | fr33z3     |

  Scenario: Willing to create my account
      Given I am a new, authenticated user
      When I go to users page
      Then I should be on the "user" page