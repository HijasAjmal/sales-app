class CreateFinanceTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :finance_transactions do |t|
      t.references :payee, :polymorphic => true
      t.references :receiver, :polymorphic => true
      t.references :finance, :polymorphic => true
      t.decimal :amount, precision: 10, scale: 2
      t.date :transaction_date

      t.timestamps
    end
  end
end
