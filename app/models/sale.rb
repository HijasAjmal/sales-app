class Sale < ApplicationRecord
	
	# associations
	belongs_to :store
	belongs_to :user

	has_many :finance_transactions, as: :finance, dependent: :destroy

	# callbacks
	after_save :find_or_create_weekend_amount_record
	after_create :create_finance_transaction


	# create or update find or create weekend amount record for each day
	def find_or_create_weekend_amount_record
		sale = self
		weekend_record = WeekendAmountRecord.find_or_create_by(:sold_date => sale.selling_date)
	end

	# create finance transaction for sale record
	def create_finance_transaction
		finance_transaction = FinanceTransaction.new
		finance_transaction.payee = self.store
		finance_transaction.receiver = User.current
		finance_transaction.finance = self
		finance_transaction.amount = self.paid_amount
		finance_transaction.transaction_date = self.selling_date
		finance_transaction.save
	end

	# create manual finance transaction for purchased item
	def self.create_sales_transaction(params)
		instant_transaction = InstantTransaction.create_instant_transaction(params)
		sales_store = Store.find_by_id(params[:receiver_id])
		last_sales_record = sales_store.sales.last if sales_store.present?
		if last_sales_record.balance_amount.to_f > 0
			transaction = FinanceTransaction.new
			transaction.payee = sales_store
			transaction.receiver = User.current
			transaction.finance = instant_transaction
			transaction.amount = params[:amount]
			transaction.transaction_date = params[:transaction_date].to_date
			if transaction.save
				last_sales_record.update(:balance_amount => last_sales_record.balance_amount.to_f - params[:amount].to_f)
			end
		end
	end
end
