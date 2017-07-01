class LineItem
  attr_accessor :product
  attr_accessor :product_count

  def initialize(product, count)
    @product = product
    @product_count = count
  end

  def total
    @product_count * @product.price
  end

  def to_s
    "#{product_count} x #{product.name}"
  end
end
