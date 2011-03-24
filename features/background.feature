@announce
Feature: As a tester, I want to generate steps from steps which are part of a background.

  Background:
    Given a typical support/env.rb file
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

  Scenario: A feature with background doesn't generate a feature with a background
    if background doesn't add any steps.
    Given a file named "features/generate_sans_background.feature" with:
      """
      Feature:

        Background: This background doesn't generate steps
          Given I don't do much

        Scenario: But the scenario does generate steps
          Given I add a step "foo"
      """
    When I run the "generate_sans_background" feature
    Then the file "features/generated_features/P123456/generate_sans_background.cw.feature" should contain "Feature:"
    And the file "features/generated_features/P123456/generate_sans_background.cw.feature" should contain "Scenario:"
    But the file "features/generated_features/P123456/generate_sans_background.cw.feature" should not contain "Background:"

  Scenario: A feature with background does generate a feature with background
    if background does add steps
    Given a file named "features/generate_sans_background.feature" with:
      """
      Feature:

        Background: This background does generate steps
          Given I add a step "bar"

        Scenario: And the scenario also generates steps
          Given I add a step "foo"
      """
    When I run the "generate_sans_background" feature
    Then the file "features/generated_features/P123456/generate_sans_background.cw.feature" should contain exactly:
      """
      @cuke_writer
      Feature: 
        [generated from features/generate_sans_background.feature]

        Background: This background does generate steps
          [from features/generate_sans_background.feature:3]
          Given I do "bar"

        Scenario: And the scenario also generates steps
          [from features/generate_sans_background.feature:6]
          Given I do "foo"

        """
