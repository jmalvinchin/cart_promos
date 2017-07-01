class Rule
  def initialize(type)
    @type = type
  end

  def execute
    puts "Execute rule process here"
  end

  def is_pricing?
    @type == "pricing"
  end

  def is_freebie?
    @type == "freebie"
  end
end
