class StepCollector
  @@scenarios = []

  def add_scenario(scenario, indent=2)
    spaces = "\n"
    indent.times { spaces << " " }
    @@scenarios << [spaces + scenario]
  end

  def add(step, indent=4)
    spaces = ""
    indent.times { spaces << " " }
    @@scenarios.last << spaces + step
  end

  def steps
    @@scenarios.select { |scenario| scenario.size > 1 }.flatten
  end

  def reset
    @@scenarios = []
  end
end
