class TotalDiscountPromoRule < Rule
  attr_accessor :promo_code

  def initialize(code, discount)
    @discount = discount
    @promo_code = code
    super("promo")
  end

  def execute(value)
    value * (1 - (@discount / 100.0))
  end
end
