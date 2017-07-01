require_relative 'models/line_item'
require_relative 'models/product'
require_relative 'models/ult_small'
require_relative 'models/ult_medium'
require_relative 'models/ult_large'
require_relative 'models/datapack'
require_relative 'services/freebie_resolver.rb'
require_relative 'services/pricing_resolver.rb'
require_relative 'rules/rule'
require_relative 'rules/bulk_discount_pricing_rule'
require 'pry'

class ShoppingCart

  def initialize(pricing_rules)
    @pricing_rules, @freebie_rules  = parse_rules(pricing_rules)
    @line_items = []
    @promo = nil
  end

  def add(item, *promo_code)
    @line_items << item
    @promo = promo_code[0] if promo_code.any?
  end

  def total
    total = PricingResolver.execute(@pricing_rules, @line_items, @promo)
    "$#{'%.2f' % total}"
  end

  def items
    cart_items = []
    @line_items = FreebieResolver.execute(@freebie_rules, @line_items)
    @line_items.each do |item|
      cart_items << item.to_s
    end
    cart_items
  end

  private
  
  def parse_rules(rules)
    pricing_rules = rules.select { |rule| rule.is_pricing? }
    freebie_rules = rules.select { |rule| rule.is_freebie? }
    return pricing_rules, freebie_rules
  end
end
