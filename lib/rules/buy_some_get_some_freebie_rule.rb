class BuySomeGetSomeFreebieRule < Rule
  def initialize(base_count, base_product, freebie_count, freebie_product)
    @base_count = base_count
    @base_product = base_product
    @freebie_count = freebie_count
    @freebie_product = freebie_product
    super("freebie")
  end

  def execute(line_item)
    if line_item.product.code == @base_product.code
      number_of_freebies = line_item.product_count / @base_count * @freebie_count
      LineItem.new(@freebie_product, number_of_freebies)
    end
  end
end
