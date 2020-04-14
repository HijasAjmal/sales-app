class CreateWeekendAmountRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :weekend_amount_records do |t|
      t.date :sold_date
      t.boolean :amount_calculated, :default => false
      t.decimal :total_amount, precision: 10, scale: 2

      t.timestamps
    end
  end
end
