Feature: Manage Profils
  In order to manage profils details
  As a security enthusiast
  I want to edit user profiles only when authorized
  
  Scenario Outline: Show or hide edit profile link
    Given the following user records
      | email           | firstname | lastname   | password | admin |
      | bob@gmail.com   | Robert    | Paulson    | secret   | false |
      | admin@gmail.com | Zaphod    | Beeblebrox | secret   | true  |
      
    Given I am logged in as "<login>" with password "secret"
    When I visit profile for "<profile>"
    Then I should <action>
    
    Examples:
      | login           | profile         | action                        |
      | admin@gmail.com | bob@gmail.com   | see key "users.show.edit"     |
      | bob@gmail.com   | bob@gmail.com   | see key "users.show.edit"     |
      |                 | bob@gmail.com   | not see key "users.show.edit" |
      | bob@gmail.com   | admin@gmail.com | not see key "users.show.edit" |


  Scenario Outline: Show or hide send notifications link
    Given the following user records
      | email           | firstname | lastname   | password | admin |
      | bob@gmail.com   | Robert    | Paulson    | secret   | false |
      | admin@gmail.com | Zaphod    | Beeblebrox | secret   | true  |

    Given I am logged in as "<login>" with password "secret"
    When I visit profile for "<profile>"
    Then I should <action>

    Examples:
      | login           | profile         | action                       |
      | admin@gmail.com | bob@gmail.com   | see "Send notifications"     |
      |                 | bob@gmail.com   | not see "Send notifications" |
      | bob@gmail.com   | admin@gmail.com | not see "Send notifications" |

