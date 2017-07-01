class BulkDiscountPricingRule < Rule
  attr_accessor :product_code
  attr_accessor :bulk_count_threshold
  attr_accessor :bulk_discount

  def initialize(code, threshold, price)
    @product_code = code
    @bulk_count_threshold = threshold
    @bulk_discount = price
    super("pricing")
  end

  def execute(line_item)
    if line_item.product.code == @product_code && line_item.product_count >= @bulk_count_threshold
      @bulk_discount * line_item.product_count
    end
  end
end
