require "rails_helper"

describe "Bulk Discounts Create" do
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

# User Story 2 - Merchant Bulk Discount Create
# As a merchant
# When I visit my bulk discounts index
# Then I see a link to create a new discount
# When I click this link
# Then I am taken to a new page where I see a form to add a new bulk discount
# When I fill in the form with valid data
# Then I am redirected back to the bulk discount index
# And I see my new bulk discount listed
  it "can click a link on the bulk discounts index to create a new bulk discount" do
    visit "/merchants/#{@merchant1.id}/bulk_discounts"
    # save_and_open_page
    click_link "New Bulk Discount"

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/new")
  end

  it "allows you to fill in a form to create a new bulk discount" do
    visit "/merchants/#{@merchant1.id}/bulk_discounts/new"

    fill_in :percentage_discount, with: (75)
    fill_in :quantity_threshold, with: (100)

    click_button("Save")
    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts")

    expect(page).to have_content(75)
    expect(page).to have_content(100)
  end

  xit "takes me back to the bulk discounts index where I see my newly created discount" do
    visit "/merchants/#{@merchant1.id}/bulk_discounts"
    # save_and_open_page
    expect(page).to have_content(75)
    expect(page).to have_content(100)
  end
end