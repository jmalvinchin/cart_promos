require_relative 'models/line_item'
require_relative 'models/product'
require_relative 'models/ult_small'
require_relative 'models/ult_medium'
require_relative 'models/ult_large'
require_relative 'models/datapack'
require_relative 'services/freebie_resolver.rb'
require_relative 'services/pricing_resolver.rb'
require_relative 'services/promo_resolver.rb'
require_relative 'rules/rule'
require_relative 'rules/bulk_discount_pricing_rule'
require_relative 'rules/more_for_less_pricing_rule'
require_relative 'rules/buy_some_get_some_freebie_rule'
require_relative 'rules/total_discount_promo_rule'
require 'pry'

class ShoppingCart

  def initialize(pricing_rules)
    @pricing_rules, @freebie_rules, @promo_rules  = parse_rules(pricing_rules)
    @line_items = []
    @total = 0
    @freebies = []
    @promos = []
  end

  def add(item, *promo_code)
    @line_items << item
    @promos << promo_code[0] if promo_code.any?
    @total += PricingResolver.execute(@pricing_rules, item)
    @freebies += FreebieResolver.execute(@freebie_rules, item)
  end

  def total
    @total = PromoResolver.execute(@promo_rules, @promos, @total)
    "$#{'%.2f' % @total}"
  end

  def items
    cart_items = []
    @line_items = FreebieResolver.sanitize_line_items(@line_items, @freebies)
    @line_items.each do |item|
      cart_items << item.to_s
    end
    cart_items
  end

  private
  
  def parse_rules(rules)
    pricing_rules = rules.select { |rule| rule.is_pricing? }
    freebie_rules = rules.select { |rule| rule.is_freebie? }
    promo_rules = rules.select { |rule| rule.is_promo? }
    return pricing_rules, freebie_rules, promo_rules
  end
end
