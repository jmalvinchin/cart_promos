class PricingResolver
  def self.execute(pricing_rules, item)
    line_item_total = 0
    if pricing_rules.any?
      pricing_rules.each do |rule|
        rule_price = rule.execute(item)
        if rule_price
          line_item_total += rule_price
        else
          line_item_total += item.total
        end
      end
    else
      line_item_total = item.total
    end

    return line_item_total
  end
end
