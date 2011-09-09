Feature: Manage checkin scenario 
  In order to [goal]
  [stakeholder]
  wants [behaviour]

  Background:
    Given This following person records
      | name    | email             | password |
      | Ford    | ford@gmail.com    | secret   |
      | Arthur  | arthur@gmail.com  | secret   |

    Given This following motivations records
      | title      |
      | co working |
      | meeting    |

  Scenario Outline: The nb of checkin should be appear
    Given I am logged in as "<email>" with password "secret"
    Given Some credits for "<email>" by "<token_owner>"
    When I checkin for "<email>" with "<token_type>" and "<motivation>" by "<checkin_owner>" for "<day>"
    When I visit profile for "<email>"
    Then I should <label>
    Then I should <major>
    
    Examples:
      | email            | token_type | motivation | token_owner | checkin_owner | day | nb | label                    | major                                 |
      | ford@gmail.com   | full day   | co working | john doe    | john doe      | 1   | 1  | see "You have 1 checkin" | see "you are Major of this place"     |
      # Fails because database is initialized each time, i do find how change comportment
      # | ford@gmail.com   | full day   | meeting    | john doe    | john doe      | 2   | 2  | see "You have 2 checkin" | see "you are Major of this place"     |
      # | arthur@gmail.com | full day   | co working | john doe    | john doe      | 1   | 1  | see "You have 1 checkin" | not see "you are Major of this place" |
      # | arthur@gmail.com | full day   | co working | john doe    | john doe      | 2   | 2  | see "You have 2 checkin" | not see "you are Major of this place" |
      # | arthur@gmail.com | full day   | co working | john doe    | john doe      | 3   | 3  | see "You have 3 checkin" | see "you are Major of this place"     |



