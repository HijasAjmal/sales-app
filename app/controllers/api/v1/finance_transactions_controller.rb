class Api::V1::FinanceTransactionsController < ApplicationController

  def index

  end

  def list_transactions
  	transactions = FinanceTransaction.fetch_finance_transactions_by_date(params[:finance_transaction][:transaction_date].to_date)
    if transactions.present?
      render json: { transactions: transactions, request_status: 200, request_message: "" }
    else
      render json: { request_status: 500, request_message: "" }
    end
  end

  def create
  	if params[:finance_transaction][:type] == "Purchase"
  		transaction = Purchase.create_purchase_transaction(params[:finance_transaction])
  	elsif params[:finance_transaction][:type] == "Sales"
  		transaction = Sale.create_sales_transaction(params[:finance_transaction])
  	end
  	if transaction.present?
      render json: { request_status: 200, request_message: "Transaction created successfully" }
    else
      render json: { request_status: 500, request_message: "Transaction failed" }
    end
  end

  def show
  end

  def destroy
  end
end
