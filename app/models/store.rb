class Store < ApplicationRecord
	# associations
	has_many :sales
	has_many :finance_transactions, as: :payee, dependent: :destroy

	# generate user wise report
	def self.generate_user_report(start_date, end_date, record_id)
		store = self.find_by(id: record_id)
		transactions = store.finance_transactions.where("finance_transactions.transaction_date BETWEEN ? AND ?", start_date.to_date, end_date.to_date)
		table_columns = ['Date', "Total weight(Kg.)", "Rate(Rs.)", "Expected amount(Rs.)", "Paid amount(Rs.)", "Balance amount(Rs.)"]
		reports_data = []
		total_item_weight = 0
		total_expected_amount = 0
		total_paid_amount = 0
		total_balance_amount = 0
		transactions.each do |transaction|
			if transaction.finance_type == "Sale"
				reports_data << [transaction.transaction_date, transaction.finance.item_weight, transaction.finance.rate, transaction.finance.expected_amount,
								transaction.finance.paid_amount, transaction.finance.balance_amount]
				total_item_weight += transaction.finance.item_weight.to_f
				total_expected_amount += transaction.finance.expected_amount.to_f
				total_paid_amount += transaction.finance.paid_amount.to_f
				total_balance_amount = transaction.finance.balance_amount.to_f
		  	else
		  		sale = transaction.payee.sales.last if transaction.payee.sales.present?
		  		reports_data << [transaction.transaction_date, '', '', '',
								transaction.amount, sale.balance_amount] if sale.present?
				total_paid_amount += transaction.amount.to_f
				total_balance_amount = sale.balance_amount.to_f
		  	end
		end
		reports_data << ['Total', total_item_weight.round(2), '', total_expected_amount.round(2), total_paid_amount.round(2), total_balance_amount.round(2)] if transactions.present?
		headerDetails = store.headerDetails(start_date, end_date)
		reports = {:tableData => reports_data, :tableHead => table_columns, :headerDetails => headerDetails}
		reports
	end

	# generating header details for report
	def headerDetails(start_date, end_date)
		final_balance_amount = self.sales.last.balance_amount.to_f if self.sales.present?
		total_credit_amount = self.finance_transactions.map(&:amount).sum.to_f if self.finance_transactions.present?
		total_debit_amount = self.sales.map(&:expected_amount).sum.to_f if self.sales.present?
		number_of_transactions = self.finance_transactions.where("finance_transactions.transaction_date BETWEEN ? AND ?", start_date.to_date, end_date.to_date).count
		report_date = Date.today.to_date.strftime('%d/%m/%Y')
		user_phone_number = User.current.phone_number
		headerDetails = {:customer_name => self.name, :final_balance_amount => final_balance_amount.round(2), :total_credit_amount => total_credit_amount.round(2),
						:total_debit_amount => total_debit_amount.round(2), :number_of_transactions => number_of_transactions, :report_genrated_at => report_date, 
						:report_date => "#{start_date.to_date.strftime('%d/%m/%Y')} - #{end_date.to_date.strftime('%d/%m/%Y')}", :user_phone_number => user_phone_number}
	end
end