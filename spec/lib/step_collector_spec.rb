require File.dirname(__FILE__) + '/../../lib/step_collector'

describe StepCollector do
  before do
    @step_collector = StepCollector.new
  end

  it "should return its steps" do
    @step_collector.steps.should == []
  end

  it "adds scenarios" do
    lambda { @step_collector.add_scenario "Scenario: We do stuff" }.should_not raise_error
  end

  it "should have an add method" do
    lambda { @step_collector.add "Given my mama didn't raise no fool" }.should_not raise_error
  end

  specify "default indent for scenario headers is two spaces" do
    @step_collector.steps.first.should == "\n  Scenario: We do stuff"
  end

  specify "default indent should be 4 spaces" do
    @step_collector.add "When I indent things look nicer"
    @step_collector.steps.last.should == "    When I indent things look nicer"
  end

  it "accumulates steps" do
    @step_collector.add "When I spin around like this"
    @step_collector.steps.should == [
      "\n  Scenario: We do stuff",
        "    Given my mama didn't raise no fool",
        "    When I indent things look nicer",
        "    When I spin around like this" ]
  end

  it "doesn't report scenarios which have no steps" do
    @step_collector.add_scenario "Scenario: We do some more stuff (but not really)"
    @step_collector.steps.should == [
      "\n  Scenario: We do stuff",
        "    Given my mama didn't raise no fool",
        "    When I indent things look nicer",
        "    When I spin around like this" ]
  end

  it "has no steps after resetting" do
    @step_collector.reset
    @step_collector.steps.should == []
  end

end
