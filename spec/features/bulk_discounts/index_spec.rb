require "rails_helper"

describe "bulk discounts index" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry")

    @discount1 = @merchant.bulkdiscounts.create(percentage_discount: 25, quantity_threshold: 10)
    @discount2 = @merchant.bulkdiscounts.create(percentage_discount: 50, quantity_threshold: 15)

    @discount3 = @merchant2.bulkdiscounts.create(percentage_discount: 10, quantity_threshold: 3)
    @discount4 = @merchant2.bulkdiscounts.create(percentage_discount: 30, quantity_threshold: 5)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
    @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
    @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

    @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
    @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)

    # @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    # @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    # @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    # @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    # @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    # @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    # @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
    # @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-28 14:54:09")
    # @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    # @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    # @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    # @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    # @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 2)

    # @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 0)
    # @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    # @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2)
    # @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1)
    # @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)
    # @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1)
    # @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1)
    # @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)

    # @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    # @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
    # @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
    # @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
    # @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
    # @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
    # @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)
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
    it "can get from the merchant dashboard to the bulk discounts index page" do
      visit "merchants/#{@merchant.id}"

      click_link "My Bulk Discounts"

      expect(current_path).to eq("merchants/#{@merchant.id}/bulk_discounts")
    end

    it "shows me all of my bulk discounts including their percentage discount and quality thresholds" do
      visit "merchants/#{@merchant.id}/bulk_discounts"

      expect(page).to have_content(@discount1.percentage_discount)
      expect(page).to have_content(@discount1.quantity_threshold)

      expect(page).to_not have_content(@discount3.percentage_discount)
      expect(page).to have_content(@discount3.quantity_threshold)

      expect(page).to_not have_content(@discount4.percentage_discount)
      expect(page).to have_content(@discount4.quantity_threshold)
    end

    xit "shows me a link for each discount that links to the item's show page" do
      within("#discount-#{@discount1.id}") do
        expect(page).to have_content("Discount #{@discount1.id}")
      end
    end
  end
end