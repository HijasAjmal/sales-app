class Api::V1::DashboardsController < ApplicationController

	def index
		total_purchase_amount = Purchase.all.sum(:total_amount).to_f
		total_sell_amount = Sale.all.sum(:expected_amount).to_f
		total_profit_amount = ((total_sell_amount.to_f - total_purchase_amount.to_f) > 0) ? (total_sell_amount.to_f - total_purchase_amount.to_f) : 0.00
		total_due_amount = total_purchase_amount - FinanceTransaction.all.where(:receiver_type => 'PurchaseStore').sum(:amount).to_f
		summary_details = { total_purchase_amount: total_purchase_amount, total_sell_amount: total_sell_amount, 
			total_profit_amount: total_profit_amount, total_due_amount: total_due_amount}
		render json: {summary_details: summary_details, request_status: 200, request_message: "" }
	end
end
