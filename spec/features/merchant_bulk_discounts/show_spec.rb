require "rails_helper"

describe "bulk discounts index" do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry")

    @discount1 = BulkDiscount.create!(percentage_discount: 10, quantity_threshold: 5, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(percentage_discount: 15, quantity_threshold: 12, merchant_id: @merchant1.id)

    @discount3 = BulkDiscount.create!(percentage_discount: 30, quantity_threshold: 20, merchant_id: @merchant2.id)
    @discount4 = BulkDiscount.create!(percentage_discount: 50, quantity_threshold: 35, merchant_id: @merchant2.id)
  end
# User Story 4 - Merchant Bulk Discount Show
# As a merchant
# When I visit my bulk discount show page
# Then I see the bulk discount's quantity threshold and percentage discount
  describe "Bulk Discounts Show Page" do
    it "I can see the bulk discount's quantity threshold and percentage discount" do
      visit "/merchants/#{@merchant1.id}/bulk_discounts/#{@discount1.id}"

      expect(page).to have_content(@discount1.percentage_discount)
      expect(page).to have_content(@discount1.quantity_threshold)
    end
  end
end