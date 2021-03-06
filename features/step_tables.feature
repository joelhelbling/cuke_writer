@announce
Feature: a step table may be passed to the step_collector to be 
  appended after the corresponding step.

  Background:
    Given a typical support/env.rb file
    And a file named "features/step_definitions/steps.rb" with:
      """
      Given /^I do "([^"]*)" with:$/ do |step_tag, table|
        @step_collector ||= StepCollector.new
        @step_collector.add "Then I put \"#{step_tag}\" on the table:", {:table => table}
      end
      """

  Scenario:
    Given a file named "features/has_a_step_table.feature" with:
      """
      Feature: Messin' wit step tables!

        Scenario: Here we go
          Given I do "this" with:
            | that  | those     |
            | thing | things    |
            | there | overthere |
      """
    When I run the "has_a_step_table" feature
    Then the file "features/generated_features/P123456/has_a_step_table.cw.feature" should contain exactly:
      """
      @cuke_writer
      Feature: Messin' wit step tables!
        [generated from features/has_a_step_table.feature]

        Scenario: Here we go
          [from features/has_a_step_table.feature:3]
          Then I put "this" on the table:
            | that  | those     |
            | thing | things    |
            | there | overthere |

      """

