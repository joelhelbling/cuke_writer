@announce
Feature: Features which have scenario outlines should generate a separate scenario
  for each pass through the scenario outlines steps (i.e. through each row in the 
  examples table).

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
      Given /^I don't do much$/ do
        :do_relatively_nothing
      end
      Given /^I add a step "([^"]*)"$/ do |step_tag|
        @step_collector ||= StepCollector.new
        @step_collector.add "Given I do \"#{step_tag}\""
      end
      """

  Scenario: a feature with a scenario outline generates a separate scenario for each example
    Given a file named "features/has_a_scenario_outline.feature" with:
      """
      Feature: Messin' wit' scenario outlines

        Scenario Outline: This is, well, you know
          Given I don't do much
          But I add a step "<step_name>"

        Examples:
          | step_name |
          | foo       |
          | bar       |
          | baz       |

        Scenario: Another scenario just to prove there are no side effects
          Given I add a step "have fun!"
      """
    When I run "cucumber features/has_a_scenario_outline.feature --format Cucumber::Formatter::CukeWriter --out cuke_writer.txt --format progress"
    Then the file "features/generated_features/P123456/has_a_scenario_outline.cw.feature" should not contain "Scenario Outline:"
    And the file "features/generated_features/P123456/has_a_scenario_outline.cw.feature" should not contain "Examples:"
    And the file "features/generated_features/P123456/has_a_scenario_outline.cw.feature" should not contain "Scenarios:"
    But the file "features/generated_features/P123456/has_a_scenario_outline.cw.feature" should contain exactly:
      """
      @cuke_writer
      Feature: Messin' wit' scenario outlines
        [generated from features/has_a_scenario_outline.feature]

        Scenario: This is, well, you know
          [from features/has_a_scenario_outline.feature:9]
          Given I do "foo"

        Scenario: This is, well, you know
          [from features/has_a_scenario_outline.feature:10]
          Given I do "bar"

        Scenario: This is, well, you know
          [from features/has_a_scenario_outline.feature:11]
          Given I do "baz"

        Scenario: Another scenario just to prove there are no side effects
          [from features/has_a_scenario_outline.feature:13]
          Given I do "have fun!"

      """

