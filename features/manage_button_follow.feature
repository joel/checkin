Feature: Manage follow button 
  In order to [goal]
  [stakeholder]
  wants [behaviour]

  Background:
    Given This following person records
      | name   | email            | password |
      | Ford   | ford@gmail.com   | secret   |
      | Arthur | arthur@gmail.com | secret   |
      | Tricia | tricia@gmail.com | secret   |
      | Robert | robert@gmail.com | secret   |
  
  Scenario Outline: The Follow button should disappear when i issue an invitation
    Given I am logged in as "<email>" with password "secret"
    When I go to people page
    When I invit "<followed>" person
    Then I should not see "request_an_invitation_for_#{User.find_by_email(<followed>).person.id}"
    
    Examples:
      | email          | followed         |
      | ford@gmail.com | arthur@gmail.com |
      
  Scenario Outline: The Follow button should disappear when I accept his invitation
    Given An invit from "<follower>" to "<followed>"
    When I accept "<followed>" invitation
    When I go to people page
    Then I should not see "request_an_invitation_for_#{User.find_by_email(<followed>).person.id}"
    
    Examples:
      | follower         | followed         |
      | tricia@gmail.com | robert@gmail.com |

    