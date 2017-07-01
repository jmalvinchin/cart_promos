class BulkDiscountPricingRule < Rule
  attr_accessor :product
  attr_accessor :bulk_count_threshold
  attr_accessor :bulk_discount

  def initialize(product, threshold, price)
    @product = product
    @bulk_count_threshold = threshold
    @bulk_discount = price
    super("pricing")
  end

  def execute(line_item)
    if line_item.product.code == @product.code && line_item.product_count >= @bulk_count_threshold
      @bulk_discount * line_item.product_count
    end
  end
end
