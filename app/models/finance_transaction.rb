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
			transactions << {:payee => f.payee_name, :receiver => f.receiver_name, :amount => f.amount.to_f, :transaction_date => f.transaction_date}
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
end
