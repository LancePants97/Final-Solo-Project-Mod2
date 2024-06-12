class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_revenue(merchant)
    total_revenue - discount_amount(merchant)
  end
  
  def discount_applied?(merchant)
    total_revenue > discounted_revenue(merchant)
  end

  def discount_amount(merchant_id) # US 6
    discounted_price = 0
    invoice_items.joins(item: :merchant).where(merchants: { id: merchant_id }).each do |invoice_item|
      bulk_discount = invoice_item.item.merchant.bulk_discounts
                                                .where("quantity_threshold <= ?", invoice_item.quantity)
                                                .order(quantity_threshold: :desc)
                                                .first

      if bulk_discount.present?
        discount_amount_per_item = invoice_item.unit_price * (bulk_discount.percentage_discount / 100.0).to_f
        total_discount_amount = invoice_item.quantity * discount_amount_per_item
        discounted_price += total_discount_amount
      end
    end
    discounted_price
  end

  def bulk_discount_for_item(item)
    merchant = item.merchant
    merchant.bulk_discounts
            .where("quantity_threshold <= ?", item.invoice_items.find_by(invoice_id: id).quantity)
            .order(quantity_threshold: :desc)
            .first
  end

  def all_merchants_discount_amount # US 8, this was original method
    discounted_price = 0
    invoice_items.each do |invoice_item|
      item = invoice_item.item
      bulk_discount = item.merchant.bulk_discounts
                        .where("quantity_threshold <= ?", invoice_item.quantity)
                        .order(quantity_threshold: :desc)
                        .first

      if bulk_discount.present?
        discount_amount_per_item = invoice_item.unit_price * (bulk_discount.percentage_discount / 100.0).to_f
        total_discount_amount = invoice_item.quantity * discount_amount_per_item
        discounted_price += total_discount_amount
      end
    end
    discounted_price
  end
end

