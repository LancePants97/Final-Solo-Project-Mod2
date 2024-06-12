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
    @merchant2 = Merchant.create!(name: 'Jewelry Store')

    @discount1 = BulkDiscount.create!(percentage_discount: 10, quantity_threshold: 5, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(percentage_discount: 15, quantity_threshold: 12, merchant_id: @merchant1.id)
    
    @discount3 = BulkDiscount.create!(percentage_discount: 15, quantity_threshold: 12, merchant_id: @merchant2.id)
    
    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id, status: 1)
    
    @item_2 = Item.create!(name: "Gold Ring", description: "This is shiny", unit_price: 15, merchant_id: @merchant2.id, status: 1)
    @item_3 = Item.create!(name: "Ring Pop", description: "This is tasty", unit_price: 10, merchant_id: @merchant2.id, status: 1)


    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    
    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2) # qualifies for discount1
    @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 13, unit_price: 5, status: 1) # qualifies for discount2
    @ii_111 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 10, unit_price: 15, status: 1) # does not qualify for discount3
    @ii_1111 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_3.id, quantity: 15, unit_price: 10, status: 1) # qualifies for discount3

    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_2.id, quantity: 10, unit_price: 15, status: 1) # does not qualify for discount3


  end

  describe "instance methods" do
    it "total_revenue" do
      invoice_1_total_rev = (@ii_1.quantity * @ii_1.unit_price) + (@ii_11.quantity * @ii_11.unit_price) + (@ii_111.quantity * @ii_111.unit_price) + (@ii_1111.quantity * @ii_1111.unit_price) # aka (9 * 10) + (13 * 5) + (10 * 15) = 305
      invoice_2_total_rev = (@ii_2.quantity * @ii_2.unit_price)
      
      expect(@invoice_1.total_revenue).to eq(invoice_1_total_rev)
      expect(@invoice_2.total_revenue).to eq(invoice_2_total_rev)
    end

    it "discount_amount(merchant_id)" do
      item1_discount = ((@ii_1.quantity * @ii_1.unit_price) * @discount1.percentage_discount)
      item8_discount = ((@ii_11.quantity * @ii_11.unit_price) * @discount2.percentage_discount)
      
      total_discount = ((item1_discount + item8_discount) / 100)
      
      expect(@invoice_1.discount_amount(@merchant1)).to eq(total_discount) # both above discount amounts (9 + 9.75 = 18.75)
      expect(@invoice_2.discount_amount(@merchant2)).to eq(0)
    end
    
    it "discounted_revenue(merchant)" do
      item1_discount = ((@ii_1.quantity * @ii_1.unit_price) * @discount1.percentage_discount)
      item8_discount = ((@ii_11.quantity * @ii_11.unit_price) * @discount2.percentage_discount)
      total_discount = ((item1_discount + item8_discount) / 100)
      
      invoice_1_total_rev = (@ii_1.quantity * @ii_1.unit_price) + (@ii_11.quantity * @ii_11.unit_price) + (@ii_111.quantity * @ii_111.unit_price) + (@ii_1111.quantity * @ii_1111.unit_price)
      invoice_2_total_rev = (@ii_2.quantity * @ii_2.unit_price)

      discounted_rev = (invoice_1_total_rev - total_discount)

      expect(@invoice_1.discounted_revenue(@merchant1)).to eq(discounted_rev) # total_revenue(455) - total_discount(18.75) = discounted_rev(436.25)
      expect(@invoice_2.discounted_revenue(@merchant2)).to eq(invoice_2_total_rev) 
    end

    it "all_merchants_discount_amount" do
      item1_discount = ((@ii_1.quantity * @ii_1.unit_price) * @discount1.percentage_discount) # merchant1 discount
      item8_discount = ((@ii_11.quantity * @ii_11.unit_price) * @discount2.percentage_discount) # merchant1 discount
      item3_discount = ((@ii_1111.quantity * @ii_1111.unit_price) * @discount3.percentage_discount) # merchant2 discount
      
      total_discount = ((item1_discount + item8_discount + item3_discount) / 100)

      expect(@invoice_1.all_merchants_discount_amount).to eq(total_discount) 
      expect(@invoice_2.all_merchants_discount_amount).to eq(0)
    end

    it "total_discounted_revenue" do
      item1_discount = ((@ii_1.quantity * @ii_1.unit_price) * @discount1.percentage_discount) # merchant1 discount
      item8_discount = ((@ii_11.quantity * @ii_11.unit_price) * @discount2.percentage_discount) # merchant1 discount
      item3_discount = ((@ii_1111.quantity * @ii_1111.unit_price) * @discount3.percentage_discount) # merchant2 discount
      total_discount = ((item1_discount + item8_discount + item3_discount) / 100)
      
      invoice_1_total_rev = (@ii_1.quantity * @ii_1.unit_price) + (@ii_11.quantity * @ii_11.unit_price) + (@ii_111.quantity * @ii_111.unit_price) + (@ii_1111.quantity * @ii_1111.unit_price)
      invoice_2_total_rev = (@ii_2.quantity * @ii_2.unit_price)

      invoice_1_discounted_rev = (invoice_1_total_rev - total_discount)
      
      expect(@invoice_1.total_discounted_revenue).to eq(invoice_1_discounted_rev)
      expect(@invoice_2.total_discounted_revenue).to eq(invoice_2_total_rev)
    end
  end
end
