Feature: Manage checkin scenario 
  In order to [goal]
  [stakeholder]
  wants [behaviour]

  Background:
    Given This following person records
      | name    | email             | password |
      | Ford    | ford1@gmail.com    | secret   |
      | Arthur  | arthur1@gmail.com  | secret   |
      | Marla   | marla@gmail.com   | secret   |
      | Stifler | stifler@gmail.com | secret   |
    Given the following user records
      | email                  | firstname             | lastname     | password | admin |
      | robert@gmail.com       | Robert                | Paulson      | secret   | false |
      | zaphod@gmail.com       | Zaphod                | Beeblebrox   | secret   | true  |
      | jbe@zorg.org           | Jean-Baptiste Emanuel | ZORG         | secret   | true  |
      | raoul@duke.com         | Raoul                 | Duke         | secret   | true  |
      | oscar@lasvegas.com    | Oscar                 | Zeta Acosta  | secret   | true  |
      | billy@glennnorris.com | Billy                 | Glenn Norris | secret   | true  |

    Given This following motivations records
      | title      |
      | co working |
      | meeting    |

  Scenario Outline: The status of presence should be appear when i checkin
    Given I am logged in as "<email>" with password "secret"
    Given Some credits for "<email>" by "<token_owner>"
    When I checkin for "<email>" with "<token_type>" and "<motivation>" by "<checkin_owner>" for "<day>"
    When I visit profile for "<email>"
    Then I should see "(I'm here to <token_type> for <motivation>)"
    
    Examples:
      | email          | token_type | motivation | token_owner | checkin_owner | day |
      | ford1@gmail.com | full day   | co working | john doe    | john doe      | nil |
      | ford1@gmail.com | half day   | meeting    | john doe    | john doe      | nil |

      
  Scenario Outline: The owner must be appear for admin
    Given I am logged in as "<email>" with password "secret"
    Given Some credits for "<email>" by "<token_owner>"
    When I checkin for "<email>" with "<token_type>" and "<motivation>" by "<checkin_owner>" for "<day>"
    When I visit profile for "<email>"
    Then I should see "(I'm here to <token_type> for <motivation>)"
    Then I should <action> "This credit was given by <token_owner_name> and This check-in was done by <checkin_owner_name>"

    Examples:
      | email                  | token_owner      | token_owner_name  | checkin_owner    | checkin_owner_name | token_type | motivation | action  | day |
      | zaphod@gmail.com       | zaphod@gmail.com | Zaphod BEEBLEBROX | zaphod@gmail.com | HimSelf            | full day   | co working | see     | nil |
      | jbe@zorg.org           | zaphod@gmail.com | Zaphod BEEBLEBROX | zaphod@gmail.com | Zaphod BEEBLEBROX  | full day   | co working | see     | nil |
      | oscar@lasvegas.com    | john doe         | Nobody            | zaphod@gmail.com | Zaphod BEEBLEBROX  | full day   | co working | see     | nil |
      | raoul@duke.com         | zaphod@gmail.com | Zaphod BEEBLEBROX | john doe         | Nobody             | full day   | co working | see     | nil |
      | billy@glennnorris.com | zaphod@gmail.com | Zaphod BEEBLEBROX | john doe         | Nobody             | full day   | co working | see     | nil |
      | robert@gmail.com       | zaphod@gmail.com | Zaphod BEEBLEBROX | john doe         | Nobody             | full day   | co working | not see | nil |

      
      
  # Scenario Outline: The numbers of avalaible tokens must be appear in checkin page
  #   Given I am logged in as "<email>" with password "secret"
  #   Given Some credits for "<email>"
  #   When I visit page of "<email>" for checkin
  #   Then I should see "Use full day credit (5)"
  #   Then I should see "Use half day credit (5)"
  #   
  #   Examples:
  #     | email          | token_type | motivation |
  #     | ford@gmail.com | full day   | co working |
    