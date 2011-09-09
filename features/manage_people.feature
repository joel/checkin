Feature: Manage people
  In order to [goal]
  [stakeholder]
  wants [behaviour]
  
  Background:
    Given that a confirmed user exists
    Given I am logged in
   
  Scenario: Register new person
    Given I am on the new person page
    When I fill in "user_firstname" with "firstname"
    # And I select 'Mr' from 'user_gender'
    And I fill in "user_lastname" with "lastname"
    And I fill in "user_company" with "company 1"
    And I fill in "user_phone" with "phone 1"
    And I press "Create User"
# <input id="new_registration_submit" name="commit" type="submit" value="sign_up" />
    Then I should see "Korben DALLAS"
    # And I should see "LASTNAME"
    # And I should see "company 1"
    # And I should see "phone 1"

