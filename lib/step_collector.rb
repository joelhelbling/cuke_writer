class StepCollector
  @@steps = []

  def add(step, indent=4)
    spaces = ""
    indent.times { spaces << " " }
    @@steps << spaces + step
  end

  def steps
    @@steps
  end

  def reset
    @@steps = []
  end
end
