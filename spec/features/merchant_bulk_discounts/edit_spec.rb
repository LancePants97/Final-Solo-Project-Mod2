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
# User Story 5 - Merchant Bulk Discount Edit
# As a merchant
# When I visit my bulk discount show page
# Then I see a link to edit the bulk discount
# When I click this link
# Then I am taken to a new page with a form to edit the discount
# And I see that the discounts current attributes are pre-poluated in the form
# When I change any/all of the information and click submit
# Then I am redirected to the bulk discount's show page
# And I see that the discount's attributes have been updated
  describe "Bulk Discounts Edit Page" do
    it "brings me to the edit page from the show page" do
      visit "/merchants/#{@merchant1.id}/bulk_discounts/#{@discount1.id}"

      expect(page).to have_content(@discount1.percentage_discount)
      expect(page).to have_content(@discount1.quantity_threshold)

      click_link("Edit")

      expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@discount1.id}/edit")
    end
    it "the form is prepopulated with the discount's current attributes and I can change them to update my discount" do 
      visit "/merchants/#{@merchant1.id}/bulk_discounts/#{@discount1.id}/edit"
      
      expect(page).to have_content("Edit Bulk Discount")
      expect(page).to have_field("Percentage discount", with: "10")
      expect(page).to have_field("Quantity threshold", with: "5")
      
      fill_in "Percentage discount", with: "11"
      fill_in "Quantity threshold", with: "6"

      click_button "Update Discount"

      expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@discount1.id}")

      expect(page).to have_content("Bulk Discount Successfully Updated")
      expect(page).to have_content("11")
      expect(page).to have_content("6")
    end
    it "the form is prepopulated with the discount's current attributes and I can change only one of them to update my discount" do 
      visit "/merchants/#{@merchant1.id}/bulk_discounts/#{@discount1.id}/edit"
      
      expect(page).to have_content("Edit Bulk Discount")
      expect(page).to have_field("Percentage discount", with: "10")
      expect(page).to have_field("Quantity threshold", with: "5")
      
      fill_in "Quantity threshold", with: "6"

      click_button "Update Discount"

      expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@discount1.id}")

      expect(page).to have_content("Bulk Discount Successfully Updated")
      expect(page).to have_content(@discount1.percentage_discount)
      expect(page).to have_content("6")
    end
  end
end