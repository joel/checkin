Feature: Manage people
  In order to [goal]
  [stakeholder]
  wants [behaviour]
  
  Background:
    Given that a confirmed user exists
    Given I am logged in
   
  Scenario: Register new person
    Given I am on the new person page
    When I fill in "person_firstname" with "firstname"
    # And I select 'Mr' from 'person_gender'
    And I fill in "person_lastname" with "lastname"
    And I fill in "person_company" with "company 1"
    And I fill in "person_phone" with "phone 1"
    And I press "Create my Person"
    Then I should see "Firstname"
    # And I should see "LASTNAME"
    # And I should see "company 1"
    # And I should see "phone 1"

