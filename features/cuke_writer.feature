Feature:

  Background:
    Given a file named "features/support/env.rb" with:
      """
      require File.dirname(__FILE__) + '/../../../../lib/cucumber/formatter/cuke_writer'
      require File.dirname(__FILE__) + '/../../../../lib/step_collector'
      """
    And a file named "features/step_definitions/steps.rb" with:
      """
      Given /^I do this$/ do
        @step_collector ||= StepCollector.new
        @step_collector.add "Given I do that"
      end
      """

  Scenario:
    Given a file named "features/cuke_writer_test.feature" with:
      """
      Feature: Testing out CukeWriter

        Scenario: A really basic scenario
          Given I do this
      """
    When I run "cucumber --format Cucumber::Formatter::CukeWriter --out cuke_writer.txt --format progress"
    Then the output should contain "1 scenario"

