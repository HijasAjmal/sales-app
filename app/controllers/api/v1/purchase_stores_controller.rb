class Api::V1::PurchaseStoresController < ApplicationController
  before_action :authenticate_request

  def index
  	purchase_stores = JSON.parse(PurchaseStore.all.select("id, name, owner_name, place, phone, email, pincode").to_json)
  	if purchase_stores.present?
	    render json: { purchase_stores: purchase_stores, request_status: 200, request_message: "" }
  	else
  	  render json: { request_status: 404, request_message: "No records found" }
  	end
  end

  def create
    purchase_store = PurchaseStore.create!(params[:purchase_store].permit(:name, :owner_name, :place, :phone, :email, :pincode))
    if purchase_store.present?
      render json: { request_status: 200, request_message: "Purchase Store created successfully" }
    else
      render json: { request_status: 500, request_message: "Purchase Store creation failed" }
    end
  end

  def list_stores
    purchase_stores = JSON.parse(PurchaseStore.all.select("id, name as value").to_json)
    if purchase_stores.present?
      render json: { purchase_stores: purchase_stores, request_status: 200, request_message: "" }
    else
      render json: { request_status: 500, request_message: "" }
    end
  end

  def update
    purchase_store = PurchaseStore.find_by_id(params[:id])
    purchase_store.update(params[:purchase_store].except(:id).permit(:name, :owner_name, :place, :phone, :email, :pincode))
    unless purchase_store.errors.present?
      render json: {request_status: 200, request_message: "Purchase Store updated successfully" }
    else
      render json: {request_status: 500, request_message: "Purchase Store updation failed" }
    end
  end

  def destroy
    purchase_store = PurchaseStore.find_by_id(params[:id])
    if purchase_store.purchases.exists?
      render json: { request_status: 200, request_message: "You cannot delete this store" }
    else
      if purchase_store.destroy
          render json: { request_status: 200, request_message: "Purchase Store deleted successfully" }
      else
          render json: { request_status: 500, request_message: "Purchase store record deletion failed" }
      end
    end
  end
end