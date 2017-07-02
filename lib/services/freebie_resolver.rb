class FreebieResolver
  def self.execute(freebie_rules, item)
    freebies = []
    freebie_rules.each do |rule|
      rule_freebies = rule.execute(item)
      freebies << rule_freebies if rule_freebies
    end
    return freebies
  end

  def self.sanitize_line_items(line_items, freebies)
    combined_list = (line_items + freebies).group_by { |item| item.product.code }
    combined_list.map do |key, val|
      if val.length == 1
        val[0]
      else
        total_product_count = val.map(&:product_count).inject(0, &:+)
        LineItem.new(val[0].product, total_product_count)
      end
    end
  end
end
