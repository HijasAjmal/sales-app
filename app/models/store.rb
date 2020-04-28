class Store < ApplicationRecord
	# associations
	has_many :sales
	has_many :finance_transactions, as: :payee, dependent: :destroy
end