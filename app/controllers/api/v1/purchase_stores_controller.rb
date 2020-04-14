class Api::V1::PurchaseStoresController < ApplicationController
  before_action :authenticate_request

  def index
  	purchase_stores = JSON.parse(PurchaseStore.all.select("id, name, owner_name, place, phone, email, pincode").to_json).each{|f| f['key'] = f["id"]}
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
  end

  def delete
  end
end