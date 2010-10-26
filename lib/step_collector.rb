class StepCollector
  @@steps = []

  def add(step)
    @@steps << step
  end

  def steps
    @@steps
  end

  def reset
    @@steps = []
  end
end
