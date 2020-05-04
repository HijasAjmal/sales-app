class Sale < ApplicationRecord
	
	# associations
	belongs_to :store
	belongs_to :user

	has_many :finance_transactions, as: :finance, dependent: :destroy

	# callbacks
	after_create :create_finance_transaction

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

	# generate sales reports
	def self.generate_report(start_date, end_date)
		table_columns = ['Store name', 'Selling date', "Total box count", "Total weight(Kg.)", "Empty box weight(Kg.)", "Item weight(Kg.)", "Rate(Rs.)", "Expected amount(Rs.)", "Paid amount(Rs.)", "Balance amount(Rs.)"]
		reports_data = []
		total_box_count = 0
		total_weight = 0
		total_expected_amount = 0
		total_item_weight = 0
		sales = JSON.parse(Sale.all.joins(:store).
			where("sales.selling_date BETWEEN ? AND ? ", "#{start_date.to_date}", "#{end_date.to_date}").
			select("sales.id, stores.name, sales.selling_date, sales.total_box_count, sales.total_weight, sales.empty_box_weight, 
				sales.item_weight, sales.rate, sales.expected_amount, sales.paid_amount, sales.balance_amount").to_json)
		if sales.present?
			sales.each do |record|
		      reports_data << [record["name"].to_s, record["selling_date"].to_s, record["total_box_count"].to_s, record["total_weight"].to_s, record["empty_box_weight"].to_s,
		  						record["item_weight"].to_s, record["rate"].to_s, record["expected_amount"].to_s, record["paid_amount"].to_s, record["balance_amount"].to_s]
		  	  total_box_count += record["total_box_count"].to_i
		  	  total_weight += record["total_weight"].to_f
		  	  total_item_weight += record["item_weight"].to_f
		  	  total_expected_amount += record["expected_amount"].to_f
		    end
		end
			total_farm_weight, total_weight_loss, total_farm_rate, total_selling_rate = self.generate_final_values_for_report(start_date, end_date, total_item_weight)
	    reports = {:tableData => reports_data, :tableHead => table_columns, 
	    	:tableSummary => {:total_box_count => total_box_count, :total_weight => total_weight, :total_item_weight => total_item_weight, 
					:total_expected_amount => total_expected_amount, :total_farm_weight => total_farm_weight, :total_weight_loss => total_weight_loss,
					:total_farm_rate => total_farm_rate, :total_selling_rate => total_selling_rate}
	    }
	end
	
	# fetch final report values
	def self.generate_final_values_for_report(start_date, end_date, total_item_weight)
		total_farm_weight = Purchase.all.where("purchase_date BETWEEN ? AND ?", start_date.to_date, end_date.to_date).map(&:total_weight).sum().to_f
		total_weight_loss = (total_farm_weight.to_f >= total_item_weight.to_f) ? total_farm_weight.to_f - total_item_weight.to_f : 0
		total_farm_rate = Purchase.all.where("purchase_date BETWEEN ? AND ?", start_date.to_date, end_date.to_date).
			select("IF(confirmed_rate > 0, total_weight*confirmed_rate, total_weight*open_rate) as purchase_amount").map(&:purchase_amount).sum().to_f
		total_selling_rate = Sale.all.where("selling_date BETWEEN ? AND ?", start_date.to_date, end_date.to_date).select('expected_amount').map(&:expected_amount).sum().to_f
		return total_farm_weight, total_weight_loss, total_farm_rate, total_selling_rate
	end
end
