Feature:

  Background:
    Given a file named "features/support/env.rb" with:
      """
      require File.dirname(__FILE__) + '/../../../../lib/cucumber/formatter/cuke_writer'
      """

  Scenario:
    When I run "cucumber --format Cucumber::Formatter::CukeWriter --out cuke_writer.txt --format progress"
    Then the output should contain "0 scenarios"

