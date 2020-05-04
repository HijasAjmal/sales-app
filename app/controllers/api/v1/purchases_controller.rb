class Api::V1::PurchasesController < ApplicationController
  before_action :authenticate_request

  def index
    
  end

  def list_purchases
    purchases = JSON.parse(Purchase.all.joins(:purchase_store).where("purchases.purchase_date = ? ", params[:purchase][:purchase_date].to_date).
      select("purchases.id, purchase_stores.name, purchases.purchase_date, purchases.open_rate, 
        purchases.confirmed_rate, purchases.total_weight, purchases.total_amount").to_json).each{|f| f['key'] = f["id"]}
    if purchases.present?
      render json: { purchases: purchases, request_status: 200, request_message: "" }
    else
      render json: { request_status: 500, request_message: "No records found" }
    end
  end

  def create
    purchase = Purchase.new(params[:purchase].permit(:purchase_store_id, :total_weight, :open_rate, :purchase_date, :confirmed_rate, :total_amount))
    purchase.user_id = @current_user.id
    if purchase.save
      render json: { request_status: 200, request_message: "Purchase created successfully" }
    else
      render json: { request_status: 500, request_message: "Purchase creation failed" }
    end
  end

  def show
    purchase = Purchase.all.where("purchases.id = ?", params[:id])
    .select("purchases.id, purchases.purchase_store_id, purchases.purchase_date, purchases.total_weight, purchases.open_rate, purchases.confirmed_rate, purchases.total_amount")
    purchase_stores = JSON.parse(PurchaseStore.all.select("id, name as value").to_json)
    if purchase.present?
      render json: { purchase: purchase, purchase_stores: purchase_stores, request_status: 200, request_message: "" }
    else
      ender json: { request_status: 500, request_message: "No records found" }
    end
  end

  def update
    purchase = Purchase.find_by_id(params[:id])
    purchase.update(params[:purchase].except(:id).permit(:purchase_store_id, :purchase_date, :total_weight, :open_rate, :confirmed_rate, :total_amount))
    if purchase.present?
      render json: { request_status: 200, request_message: "Purchase updated successfully" }
    else
      render json: { request_status: 500, request_message: "Purchase updation failed" }
    end
  end

  def destroy
    purchase = Purchase.find_by_id(params[:id])
    sales = Sale.all.where("selling_date = ?", purchase.purchase_date)
    if !sales.present? && purchase.destroy
      render json: { request_status: 200, request_message: "Purchase record deleted successfully" }
    elsif sales.present?
      render json: { request_status: 200, request_message: "Cannot delete the purchase record" }
    else
      render json: { request_status: 500, request_message: "Purchase record deletion failed" }
    end
  end
  
  def fetch_total_due_amount
    purchase_amount = Purchase.all.where(purchase_store_id: params[:purchase][:id]).select("IF(confirmed_rate > 0, total_weight*confirmed_rate, total_weight*open_rate) as purchase_amount").map(&:purchase_amount).sum().to_f
    paid_amount = PurchaseStore.find_by(id: params[:purchase][:id]).finance_transactions.map(&:amount).sum().to_f
    due_amount = 0
    if purchase_amount > paid_amount
      due_amount += (purchase_amount.to_f - paid_amount.to_f)
      render json: { due_amount: due_amount, request_status: 200, request_message: "" }
    else
      ender json: { request_status: 500, request_message: "" }
    end
  end
end
