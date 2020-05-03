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

	# generate purchase reports
	def self.generate_report(start_date, end_date)
		table_columns = ['Store name', 'Purchase date', "Total weight(Kg.)", "Open rate(Rs.)", "Confirmed rate(Rs.)", "Total amount(Rs.)"]
		reports_data = []
		total_weight = 0
		total_amount = 0
		purchases = JSON.parse(Purchase.all.joins(:purchase_store)
			.where("purchases.purchase_date BETWEEN ? AND ? ", "#{start_date.to_date}", "#{end_date.to_date}")
			.select("purchases.id, purchase_stores.name, purchases.purchase_date, purchases.open_rate, 
				purchases.confirmed_rate, purchases.total_weight, purchases.total_amount").to_json)
		if purchases.present?
			purchases.each do |record|
		      reports_data << [record["name"].to_s, record["purchase_date"].to_s, record["total_weight"].to_s, record["open_rate"].to_s, record["confirmed_rate"].to_s,
		  						record["total_amount"].to_s]
		  	  total_weight += record["total_weight"].to_f
		  	  total_amount += record["total_amount"].to_f
		    end
		end
	    reports = {:tableData => reports_data, :tableHead => table_columns, :tableSummary => {:total_weight => total_weight, :total_amount => total_amount}}
	end
end
