class Floor
  def labs
  end

  def machines
    labs.map { |lab| lab.machines }.flatten
  end

  def printers
    labs.map { |lab| lab.printers }.flatten
  end
end
