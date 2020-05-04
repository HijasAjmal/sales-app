class CreateSales < ActiveRecord::Migration[6.0]
  def change
    create_table :sales do |t|
      t.integer :store_id
      t.date :selling_date
      t.integer :total_box_count
      t.decimal :total_weight, precision: 10, scale: 2
      t.decimal :empty_box_weight, precision: 10, scale: 2
      t.decimal :item_weight, precision: 10, scale: 2
      t.decimal :rate, precision: 10, scale: 2
      t.decimal :expected_amount, precision: 10, scale: 2
      t.decimal :paid_amount, precision: 10, scale: 2, :default => 0
      t.decimal :balance_amount, precision: 10, scale: 2, :default => 0
      t.integer :user_id
      t.boolean :is_deleted, :default => false

      t.timestamps
    end
  end
end
