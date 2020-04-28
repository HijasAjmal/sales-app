class InstantTransaction < ApplicationRecord
	# validations
	validates_presence_of :amount, :transaction_date
	# associations
	has_many :finance_transactions, as: :finance, dependent: :destroy

	# create instant transaction
	def self.create_instant_transaction(params)
		instant_transaction = InstantTransaction.new
		instant_transaction.amount = params[:amount]
		instant_transaction.transaction_date = params[:transaction_date]
		instant_transaction.save
		instant_transaction
	end
end
