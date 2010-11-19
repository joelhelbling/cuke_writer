class StepCollector
  @@scenarios = []

  def add_scenario(scenario, p={})
    indent = p[:indent] || 2
    spaces = "\n" + " " * indent
    @@scenarios << [ spaces + scenario ]
  end

  def add(step, p={})
    table  = p[:table]
    indent = p[:indent] || 4
    spaces = " " * indent
    @@scenarios.last << spaces + step + prettified(table).to_s
  end

  def steps
    @@scenarios.select { |scenario| scenario.size > 1 }.flatten
  end

  def reset
    @@scenarios = []
  end

  def prettified(table, indent=4)
    return nil unless table
    table.to_s(:color => false, :indent => indent + 2).gsub(/\|  +/, "| ").gsub(/\s+$/, '')
  end
end
