class MoreForLessPricingRule < Rule
  def initialize(code, more_count, less_count)
    @product_code = code
    @more_count = more_count
    @less_count = less_count
    super("pricing")
  end

  def execute(line_item)
    less_price = line_item.product.price * @less_count
    number_of_sets = line_item.product_count / @more_count
    excess_count = line_item.product_count % @more_count
    (less_price * number_of_sets) + (line_item.product.price * excess_count)
  end
end
