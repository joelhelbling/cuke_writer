Given /^I do this$/ do
  @step_collector ||= StepCollector.new
  @step_collector.add "Given I do that"
end