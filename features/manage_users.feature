Feature: Manage users
  In order to [goal]
  [stakeholder]
  wants [behaviour]

  # Scenario Outline: Creating a new account
  #     Given I am not authenticated
  #     When I go to register # define this path mapping in features/support/paths.rb, usually as '/users/sign_up'
  #     And I fill in "user_email" with "<email>"
  #     And I fill in "user_password" with "<password>"
  #     And I fill in "user_password_confirmation" with "<password>"
  # 			And I fill in "user_firstname" with "<firstname>"
  # 			And I fill in "user_lastname" with "<lastname>"
  # 			# And I fill in "user_gender" with "<gender>"
  # 			And I fill in "user_company" with "<company>"
  # 			And I fill in "user_phone" with "<phone>"
  #     And I press "new_registration_submit"
  #     # Then I should see "Signed in successfully." # should be work ?!
  #     Then I should see "New person"
  # 
  #     Examples:
  #       | email           | password   | firstname | lastname | gender | company | phone      |
  #       | testing@man.net | secretpass | test      | test     | Mr     | test    | 0678765434 |
  #       | foo@bar.com     | fr33z3     | test      | test     | Mr     | test    | 0678765434 |

  Scenario: Willing to create my account
      Given I am a new, authenticated user
      When I go to people page
      Then I should be on the "people page" page