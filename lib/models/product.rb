class Product
  attr_accessor :code
  attr_accessor :name
  attr_accessor :price

  def initialize(code, name, price)
    @code = code
    @name = name
    @price = price
  end
end
