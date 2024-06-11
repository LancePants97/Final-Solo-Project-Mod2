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

  def discount_amount
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
    return discounted_price
  end

  def bulk_discount_for_item(item)
    merchant = item.merchant
    merchant.bulk_discounts
            .where("quantity_threshold <= ?", item.invoice_items.find_by(invoice_id: id).quantity)
            .order(quantity_threshold: :desc)
            .first
  end

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_revenue
    total_revenue - discount_amount
  end
  
  def discount_applied?
    total_revenue > discounted_revenue
  end
end