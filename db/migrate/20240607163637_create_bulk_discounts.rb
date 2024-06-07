class CreateBulkDiscounts < ActiveRecord::Migration[7.1]
  def change
    create_table :bulk_discounts do |t|
      t.integer :percentage_discount
      t.integer :quantity_threshold

      t.timestamps
    end
  end
end
