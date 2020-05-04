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
    finance_transaction = FinanceTransaction.find_by(id: params[:id])
    if finance_transaction.payee_type == 'Store'
      if finance_transaction.payee.sales.present?
        finance_transaction.payee.sales.last.update(:balance_amount => (finance_transaction.payee.sales.last.balance_amount.to_f + finance_transaction.amount.to_f))
      end
    end
    if finance_transaction.destroy
      render json: { request_status: 200, request_message: "Transaction deleted successfully" }
    else
      render json: { request_status: 500, request_message: "Transaction deletion faild" }
    end
  end
end
