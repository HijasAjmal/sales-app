class Sale < ApplicationRecord
	
	# associations
	belongs_to :store
	belongs_to :user

	# callbacks
	after_save :find_or_create_weekend_amount_record


	# create or update find or create weekend amount record for each day
	def find_or_create_weekend_amount_record
		sale = self
		weekend_record = WeekendAmountRecord.find_or_create_by(:sold_date => sale.selling_date)
	end
end
