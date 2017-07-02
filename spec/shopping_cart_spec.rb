require 'spec_helper'
require_relative '../lib/shopping_cart'

describe ShoppingCart do
  let(:pricing_rules) { [] }
  let(:freebie_rules) { [] }
  let(:shopping_cart) { ShoppingCart.new(pricing_rules) }
  let(:product_small) { UltSmall.new }
  let(:product_medium) { UltMedium.new }
  let(:product_large) { UltLarge.new }
  let(:product_datapack) { Datapack.new }
  let(:line_items) { [line_item_1, line_item_2] }

  context "3 for 2 promo" do
    let(:line_item_2) { LineItem.new(product_large, 1) }

    let(:pricing_rules) { [MoreForLessPricingRule.new("ult_small", 3, 2)] }

    before do
      shopping_cart.add(line_item_1)
      shopping_cart.add(line_item_2)

      allow(FreebieResolver).to receive(:execute).with(freebie_rules, line_items).and_return(line_items)
    end

    context "exact 3 items" do
      let(:line_item_1) { LineItem.new(product_small, 3) }

      it "applies the correct 3 for 2 pricing" do
        expect(shopping_cart.total).to eq "$94.70"
        expect(shopping_cart.items).to eq ["3 x Unlimited 1 GB", "1 x Unlimited 5 GB"]
      end
    end

    context "excess of 1 for the 3 for 2 price" do
      let(:line_item_1) { LineItem.new(product_small, 4) }

      it "applies the correct 3 for 2 pricing" do
        expect(shopping_cart.total).to eq "$119.60"
        expect(shopping_cart.items).to eq ["4 x Unlimited 1 GB", "1 x Unlimited 5 GB"]
      end
    end

    context "6 for 4" do
      let(:line_item_1) { LineItem.new(product_small, 6) }

      it "applies the correct 3 for 2 pricing" do
        expect(shopping_cart.total).to eq "$144.50"
        expect(shopping_cart.items).to eq ["6 x Unlimited 1 GB", "1 x Unlimited 5 GB"]
      end
    end
  end


  context "bulk discount promo" do
    let(:line_item_1) { LineItem.new(product_small, 2) }
    let(:line_item_2) { LineItem.new(product_large, 4) }

    let(:pricing_rules) { [BulkDiscountPricingRule.new(product_large, 3, 39.9)] }

    before do
      shopping_cart.add(line_item_1)
      shopping_cart.add(line_item_2)

      allow(FreebieResolver).to receive(:execute).with(freebie_rules, line_items).and_return(line_items)
    end

    it "applies the correct bulk order pricing" do
      expect(shopping_cart.total).to eq "$209.40"
      expect(shopping_cart.items).to eq ["2 x Unlimited 1 GB", "4 x Unlimited 5 GB"]
    end
  end

  context "freebies" do
    let(:line_item_1) { LineItem.new(product_small, 1) }
    let(:line_item_2) { LineItem.new(product_medium, 2) }
    let(:line_item_3) { LineItem.new(product_datapack, 2) }

    let(:expected_line_items) { [line_item_1, line_item_2, line_item_3] }


    before do
      shopping_cart.add(line_item_1)
      shopping_cart.add(line_item_2)
    end

    context "different freebies" do
      let(:pricing_rules) { [BuySomeGetSomeFreebieRule.new(1, product_medium, 1, product_datapack)] }

      it "applies the additional freebies to the items" do
        expect(shopping_cart.total).to eq "$84.70"
        expect(shopping_cart.items).to eq ["1 x Unlimited 1 GB", "2 x Unlimited 2 GB", "2 x 1 GB Data-pack"]
      end
    end

    context "same freebies" do
      let(:pricing_rules) { [BuySomeGetSomeFreebieRule.new(1, product_medium, 1, product_medium)] }

      it "applies the additional freebies to the items" do
        expect(shopping_cart.total).to eq "$84.70"
        expect(shopping_cart.items).to eq ["1 x Unlimited 1 GB", "4 x Unlimited 2 GB"]
      end
    end

    context "different number of freebies" do
      let(:pricing_rules) { [BuySomeGetSomeFreebieRule.new(2, product_medium, 1, product_datapack)] }

      it "applies the additional freebies to the items" do
        expect(shopping_cart.total).to eq "$84.70"
        expect(shopping_cart.items).to eq ["1 x Unlimited 1 GB", "2 x Unlimited 2 GB", "1 x 1 GB Data-pack"]
      end
    end
  end

  context "promo code discount" do
    let(:line_item_1) { LineItem.new(product_small, 1) }
    let(:line_item_2) { LineItem.new(product_datapack, 1) }

    let(:pricing_rules) { [TotalDiscountPromoRule.new("I<3AMAYSIM", 10)] }

    before do
      shopping_cart.add(line_item_1)
      shopping_cart.add(line_item_2, "I<3AMAYSIM")
    end

    it "applies the discount to the item total" do
      expect(shopping_cart.total).to eq "$31.32"
      expect(shopping_cart.items).to eq ["1 x Unlimited 1 GB", "1 x 1 GB Data-pack"]
    end
  end
end
