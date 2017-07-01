class PricingResolver
  def self.execute(pricing_rules, line_items, promo)
    total = 0
    if pricing_rules.any?
      line_items.each do |item|
        total += execute_rules(pricing_rules, item)
      end
    else
      line_items.each do |item|
        total += item.total
      end
    end
    return total
  end

  private

  def self.execute_rules(pricing_rules, item)
    line_item_total = 0
    pricing_rules.each do |rule|
      rule_price = rule.execute(item)
      if rule_price
        line_item_total += rule_price
      else
        line_item_total += item.total
      end
    end
    return line_item_total
  end
end
