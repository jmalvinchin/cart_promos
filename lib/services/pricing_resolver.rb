class PricingResolver
  def self.execute(pricing_rules, item)
    line_item_total = 0
    if pricing_rules.any?
      pricing_rules.each do |rule|
        rule_price = rule.execute(item)
        line_item_total += rule_price if rule_price
      end
    end
    line_item_total = item.total if line_item_total == 0

    return line_item_total
  end
end
