class Rule
  def initialize(type)
    @type = type
  end

  def is_pricing?
    @type == "pricing"
  end

  def is_freebie?
    @type == "freebie"
  end

  def is_promo?
    @type == "promo"
  end
end
