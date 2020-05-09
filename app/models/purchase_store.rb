class PurchaseStore < ApplicationRecord
	# associations
	has_many :purchases
	has_many :finance_transactions, as: :receiver, dependent: :destroy

	# generate user wise report
	def self.generate_user_report(start_date, end_date, record_id)
		store = self.find_by(id: record_id)
		transactions = store.finance_transactions.where("finance_transactions.transaction_date BETWEEN ? AND ?", start_date.to_date, end_date.to_date)
		table_columns = ['Date', "Payer name", "Paid amount(Rs.)"]
		reports_data = []
		total_paid_amount = 0
		transactions.each do |transaction|
			reports_data << [transaction.transaction_date, transaction.payee_name, transaction.amount]
			total_paid_amount += transaction.amount.to_f
		end
		reports_data << ['Total', '', total_paid_amount] if transactions.present?
		headerDetails = store.headerDetails(start_date, end_date)
		reports = {:tableData => reports_data, :tableHead => table_columns, :headerDetails => headerDetails}
		reports
	end

	# generating header details for report
	def headerDetails(start_date, end_date)
		purchase_amount = self.purchases.select("IF(confirmed_rate > 0, total_weight*confirmed_rate, total_weight*open_rate) as purchase_amount").map(&:purchase_amount).sum().to_f
		final_balance_amount = self.finance_transactions.present? ? (purchase_amount.to_f - self.finance_transactions.map(&:amount).sum.to_f) : purchase_amount.to_f
		total_credit_amount = purchase_amount.to_f
		total_debit_amount = self.finance_transactions.map(&:amount).sum.to_f if self.finance_transactions.present?
		number_of_transactions = self.finance_transactions.where("finance_transactions.transaction_date BETWEEN ? AND ?", start_date.to_date, end_date.to_date).count
		report_date = Date.today.to_date.strftime('%d/%m/%Y')
		user_phone_number = User.current.phone_number
		headerDetails = {:customer_name => self.name, :final_balance_amount => final_balance_amount, :total_credit_amount => total_credit_amount,
						:total_debit_amount => total_debit_amount, :number_of_transactions => number_of_transactions, :report_genrated_at => report_date, 
						:report_date => "#{start_date.to_date.strftime('%d/%m/%Y')} - #{end_date.to_date.strftime('%d/%m/%Y')}", :user_phone_number => user_phone_number}
	end
end
