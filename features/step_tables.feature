@announce
Feature: a step table may be passed to the step_collector to be 
  appended after the corresponding step.

  Background:
    Given a file named "features/support/env.rb" with:
      """
      require File.dirname(__FILE__) + '/../../../../lib/cucumber/formatter/cuke_writer'
      require File.dirname(__FILE__) + '/../../../../lib/step_collector'
      require File.dirname(__FILE__) + '/../../../../lib/serial_number'

      SerialNumber.number = "P123456"
      """
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
    When I run "cucumber features/has_a_step_table.feature --format Cucumber::Formatter::CukeWriter --out cuke_writer.txt --format progress"
    Then the file "features/generated_features/P123456/has_a_step_table.cw.feature" should contain exactly:
      """
      Feature: Messin' wit step tables!
        [generated from features/has_a_step_table.feature]

        Scenario: Here we go
          [from features/has_a_step_table.feature:3]
          Then I put "this" on the table:
            | that  | those     |
            | thing | things    |
            | there | overthere |

      """

