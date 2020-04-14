class Purchase < ApplicationRecord
	# associations
	belongs_to :purchase_store
	belongs_to :user
end
