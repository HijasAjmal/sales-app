class FinanceTransaction < ApplicationRecord

	# associations
	belongs_to :payee, :polymorphic => true
	belongs_to :receiver, :polymorphic => true
	belongs_to :finance, :polymorphic => true

	# validations
	validates_presence_of :payee, :receiver, :finance, :amount, :transaction_date

	# fetch all finance transaction by given date
	def self.fetch_finance_transactions_by_date(date)
		transactions = []
		FinanceTransaction.all.where("transaction_date = ?", date).each do |f|
			transactions << {:id => f.id, :payee => f.payee_name, :receiver => f.receiver_name, :finance_type => f.finance_type, :amount => f.amount.to_f, :transaction_date => f.transaction_date}
		end
		transactions
	end

	# fetch receiver name for transaction
	def receiver_name
		if self.receiver_type == "User"
			self.receiver.full_name
		else
			self.receiver.name
		end
	end

	# fetch payee name for transaction
	def payee_name
		if self.payee_type == "User"
			self.payee.full_name
		else
			self.payee.name
		end
	end

	# generate finance transactions reports
	def self.generate_report(start_date, end_date)
		table_columns = ['Payer name', 'Receiver name', "Transaction type", "Transaction date", "Amount(Rs.)"]
		reports_data = []
		total_amount = 0
		FinanceTransaction.all.where("transaction_date BETWEEN ? AND ?", start_date.to_date, end_date.to_date).each do |f|
			reports_data << [f.payee_name, f.receiver_name, f.finance_type, f.transaction_date, f.amount.to_f,]
			total_amount += f.amount.to_f
		end
		reports_data
	    reports = {:tableData => reports_data, :tableHead => table_columns, :tableSummary => {:total_amount => total_amount}}
	end
end
