class CreatePurchaseStores < ActiveRecord::Migration[6.0]
  def change
    create_table :purchase_stores do |t|
      t.string :name
      t.string :owner_name
      t.string :place
      t.string :phone
      t.string :email
      t.string :pincode
      t.boolean :is_deleted, :default => false

      t.timestamps
    end
  end
end
