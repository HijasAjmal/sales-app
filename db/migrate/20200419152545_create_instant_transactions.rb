class CreateInstantTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :instant_transactions do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.date :transaction_date

      t.timestamps
    end
  end
end
