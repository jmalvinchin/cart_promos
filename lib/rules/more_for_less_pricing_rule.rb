class MoreForLessPricingRule < Rule
  def initialize(product, more_count, less_count)
    @product = product
    @more_count = more_count
    @less_count = less_count
    super("pricing")
  end

  def execute(line_item)
    if line_item.product.code == @product.code
      less_price = line_item.product.price * @less_count
      number_of_sets = line_item.product_count / @more_count
      excess_count = line_item.product_count % @more_count
      (less_price * number_of_sets) + (line_item.product.price * excess_count)
    end
  end
end
