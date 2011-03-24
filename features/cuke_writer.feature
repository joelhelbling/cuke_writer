@announce
Feature: features with simple, straightforward scenarios

  Background:
    Given a typical support/env.rb file
    And a file named "features/step_definitions/steps.rb" with:
      """
      Given /^I do this$/ do
        @step_collector ||= StepCollector.new
        @step_collector.add "Given I do that"
      end
      """

  Scenario: A basic single-scenario feature with indentation
    Given a file named "features/cuke_writer_test.feature" with:
      """
      Feature: Testing out CukeWriter

        Scenario: A really basic scenario
          Given I do this
      """
    When I run the "cuke_writer_test" feature
    Then it should pass with: 
      """
      1 scenario (1 passed)
      1 step (1 passed)
      """
    And the following directories should exist:
      | features/generated_features/P123456 |
    And the following files should exist:
      | features/generated_features/P123456/cuke_writer_test.cw.feature |
    And the file "features/generated_features/P123456/cuke_writer_test.cw.feature" should contain exactly:
      """
      @cuke_writer
      Feature: Testing out CukeWriter
        [generated from features/cuke_writer_test.feature]

        Scenario: A really basic scenario
          [from features/cuke_writer_test.feature:3]
          Given I do that

      """

  Scenario: When no steps are added, don't write a scenario
    Given a file named "features/suppress_empty_scenarios.feature" with:
      """
      Feature: Testing out CukeWriter

        Scenario: that doesn't write a step
          Given I don't do much

        Scenario: that does write a step
          Given I do this
      """
    And I append to "features/step_definitions/steps.rb" with:
      """

      Given /^I don't do much$/ do
        :do_relatively_nothing
      end

      """
    When I run the "suppress_empty_scenarios" feature
    Then the file "features/generated_features/P123456/suppress_empty_scenarios.cw.feature" should contain exactly:
      """
      @cuke_writer
      Feature: Testing out CukeWriter
        [generated from features/suppress_empty_scenarios.feature]

        Scenario: that does write a step
          [from features/suppress_empty_scenarios.feature:6]
          Given I do that

      """

  Scenario: When no scenarios are written, don't write a feature
    Given a file named "features/suppress_empty_features.feature" with:
      """
      Feature: Look Ma, no steps!

        Scenario: this guy don't do nuthin'
          Given I don't do much

        Scenario: this guy doesn't do anything either
          Given I don't do much
      """
    And I append to "features/step_definitions/steps.rb" with:
      """

      Given /^I don't do much$/ do
        :do_relatively_nothing
      end

      """
    When I run the "suppress_empty_scenarios" feature
    Then the following files should not exist:
      | features/supress_empty_features.feature |

