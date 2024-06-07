class AddMerchantToBulkDiscounts < ActiveRecord::Migration[7.1]
  def change
    add_reference :bulk_discounts, :merchant, null: false, foreign_key: true
  end
end
