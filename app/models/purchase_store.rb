class PurchaseStore < ApplicationRecord
	# associations
	has_many :purchases
	has_many :finance_transactions, as: :receiver, dependent: :destroy
end
