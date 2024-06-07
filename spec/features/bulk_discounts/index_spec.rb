require "rails_helper"

describe "bulk discounts index" do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry")

    @discount1 = BulkDiscount.create!(percentage_discount: 10, quantity_threshold: 5, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(percentage_discount: 15, quantity_threshold: 10, merchant_id: @merchant1.id)

    @discount3 = BulkDiscount.create!(percentage_discount: 30, quantity_threshold: 20, merchant_id: @merchant2.id)
    @discount4 = BulkDiscount.create!(percentage_discount: 50, quantity_threshold: 35, merchant_id: @merchant2.id)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
    @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
    @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

    @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
    @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)
  end
# User Story 1 - Merchant Bulk Discounts Index
# As a merchant
# When I visit my merchant dashboard
# Then I see a link to view all my discounts
# When I click this link
# Then I am taken to my bulk discounts index page
# Where I see all of my bulk discounts including their
# percentage discount and quantity thresholds
# And each bulk discount listed includes a link to its show page
  describe "Bulk Discounts Index" do
    it "can click a link to get from the merchant dashboard to the bulk discounts index page" do
      visit "/merchants/#{@merchant1.id}/dashboard"
     
      click_link "My Bulk Discounts"

      expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts")
    end

    it "shows me all of my bulk discounts including their percentage discount and quality thresholds" do
      visit "/merchants/#{@merchant1.id}/bulk_discounts"
      
      expect(page).to have_content("Bulk Discounts for #{@merchant1.name}")

      within("#discounts") do
        expect(page).to have_content(@discount1.percentage_discount)
        expect(page).to have_content(@discount1.quantity_threshold)

        expect(page).to have_content(@discount2.percentage_discount)
        expect(page).to have_content(@discount2.quantity_threshold)

        expect(page).to_not have_content(@discount3.percentage_discount)
        expect(page).to_not have_content(@discount3.quantity_threshold)

        expect(page).to_not have_content(@discount4.percentage_discount)
        expect(page).to_not have_content(@discount4.quantity_threshold)
      end
    end

    it "shows me a link for each discount that links to the item's show page" do
      visit "/merchants/#{@merchant1.id}/bulk_discounts"
      save_and_open_page
      within("#discount-#{@discount1.id}") do
        expect(page).to have_content(@discount1.percentage_discount)
        expect(page).to have_content(@discount1.quantity_threshold)

        click_link("Info")

        expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@discount1.id}")
      end
    end
  end
end