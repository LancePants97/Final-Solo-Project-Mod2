require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
    it { should have_many(:bulk_discounts).through(:merchants) }
  end
  before(:each) do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @discount1 = BulkDiscount.create!(percentage_discount: 10, quantity_threshold: 5, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(percentage_discount: 15, quantity_threshold: 12, merchant_id: @merchant1.id)
    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
    @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 13, unit_price: 5, status: 1)
  end

  describe "instance methods" do
    it "total_revenue" do
      total_rev = (@ii_1.quantity * @ii_1.unit_price) + (@ii_11.quantity * @ii_11.unit_price) # aka (10 * 9) + (5 * 13) = 155
  
      expect(@invoice_1.total_revenue).to eq(total_rev)
    end

  # item1 qualifies for discount1 (at least 5 items) | discount amount should be 9
  # item2 qualifies for discount2 (at least 12 items) | discount amount should be 9.75 (NOT 6.5!)
    it "discount_amount" do
      item1_discount = ((@ii_1.quantity * @ii_1.unit_price) * @discount1.percentage_discount)
      item8_discount = ((@ii_11.quantity * @ii_11.unit_price) * @discount2.percentage_discount)
      total_discount = ((item1_discount + item8_discount) / 100)

      expect(@invoice_1.discount_amount).to eq(total_discount) # both above discount amounts (9 + 9.75 = 18.75)
    end

    it "discounted_revenue" do
      total_rev = (@ii_1.quantity * @ii_1.unit_price) + (@ii_11.quantity * @ii_11.unit_price)
      item1_discount = ((@ii_1.quantity * @ii_1.unit_price) * @discount1.percentage_discount)
      item8_discount = ((@ii_11.quantity * @ii_11.unit_price) * @discount2.percentage_discount)
      total_discount = ((item1_discount + item8_discount) / 100)
      discounted_rev = (total_rev - total_discount)

      expect(@invoice_1.discounted_revenue).to eq(discounted_rev) # total_revenue(155) - discount_amount(18.75)
    end

    it "bulk_discount_for_item(item)" do
      expect(@invoice_1.bulk_discount_for_item(@item_1)).to eq(@discount1)
      expect(@invoice_1.bulk_discount_for_item(@item_8)).to eq(@discount2)
    end

    it "discount_applied?" do
      expect(@invoice_1.discount_applied?).to be(true)
    end
  end
end
