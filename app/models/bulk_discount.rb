class BulkDiscount < ApplicationRecord
  validates_presence_of :percentage_discount, :quantity_threshold
  validates_numericality_of :percentage_discount, :quantity_threshold, only_integer: true

  belongs_to :merchant
end