@announce
Feature: Here is a feature (let's call him "Bob") who uses aruba
  to write and then run a feature which uses CukeWriter to write
  another feature which Bob then runs and verifies its output.
  Great job, Bob!

  Background:
    Given a typical support/env.rb file
    And a file named "features/step_definitions/steps.rb" with:
      """
      Given /^I wrote this with aruba$/ do
        @step_collector ||= StepCollector.new
        @step_collector.add "Then I wrote this with CukeWriter"
      end
      Then /^I wrote this with CukeWriter$/ do
        puts "Hi, Bob!"
      end
      """

  Scenario: Bob writes and runs a feature, and then runs the feature written by that feature (via CukeWriter)
    Given a file named "features/bobs_end_to_end.feature" with:
      """
      Feature: Bob writes a feature that writes a feature

        Scenario: here is Bob's scenario
          Given I wrote this with aruba

      """
    When I run the "bobs_end_to_end" feature
    And I run `cucumber features/generated_features/P123456/bobs_end_to_end.cw.feature --no-color --no-source -r features/`
    Then it should pass with:
      """
      1 scenario (1 passed)
      1 step (1 passed)
      """
    And the output should contain:
      """
      Hi, Bob!
      """
