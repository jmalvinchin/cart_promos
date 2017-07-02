class PromoResolver
  def self.execute(promo_rules, promo_codes, total)
    promo_rules_hash = promo_rules.each_with_object({}) { |promo,hash| hash[promo.promo_code] = promo }
    promo_codes.each do |code|
      total = promo_rules_hash[code].execute(total) if promo_rules_hash[code]
    end
    return total
  end
end
