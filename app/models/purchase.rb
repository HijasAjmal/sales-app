class Purchase < ApplicationRecord
	# associations
	belongs_to :purchase_store
	belongs_to :user
	has_many :finance_transactions, as: :finance, dependent: :destroy

	# create manual finance transaction for purchased item
	def self.create_purchase_transaction(params)
		instant_transaction = InstantTransaction.create_instant_transaction(params)
		purchase_store = PurchaseStore.find_by_id(params[:receiver_id])
		transaction = FinanceTransaction.new
		transaction.payee = User.current
		transaction.receiver = purchase_store
		transaction.finance = instant_transaction
		transaction.amount = params[:amount]
		transaction.transaction_date = params[:transaction_date].to_date
		transaction.save
	end
end
