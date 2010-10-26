require File.dirname(__FILE__) + '/../../lib/step_collector'

describe StepCollector do
  before do
    @step_collector = StepCollector.new
  end

  it "should return its steps" do
    @step_collector.steps.should == []
  end

  it "should have an add method" do
    lambda { @step_collector.add "Given my mama didn't raise no fool" }.should_not raise_error
  end

  it "should accumulate steps" do
    @step_collector.add "When I spin around like this"
    @step_collector.steps.should == ["Given my mama didn't raise no fool", "When I spin around like this"]
  end

  it "should have no steps after resetting" do
    @step_collector.reset
    @step_collector.steps.should == []
  end

end
