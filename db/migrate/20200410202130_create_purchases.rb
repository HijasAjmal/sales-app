class CreatePurchases < ActiveRecord::Migration[6.0]
  def change
    create_table :purchases do |t|
      t.integer :purchase_store_id
      t.date :purchase_date
      t.decimal :total_weight, precision: 10, scale: 2
      t.decimal :open_rate, precision: 10, scale: 2
      t.decimal :confirmed_rate, precision: 10, scale: 2
      t.decimal :total_amount, precision: 10, scale: 2
      t.integer :user_id
      t.boolean :is_deleted, :default => false

      t.timestamps
    end
  end
end
