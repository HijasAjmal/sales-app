class Api::V1::StoresController < ApplicationController
	before_action :authenticate_request
	def index
		stores = JSON.parse(Store.all.select("id, name, owner_name, place, phone, email, pincode").to_json).each{|f| f['key'] = f["id"]}
	  	if stores.present?
		   render json: { stores: stores, request_status: 200, request_message: "" }
	  	else
	  	  render json: { request_status: 500, request_message: "No records found" }
	  	end
	end

	def create
		store = Store.create!(params[:store].permit(:name, :owner_name, :place, :phone, :email, :pincode))
	    if store.present?
	      render json: { request_status: 200, request_message: "Store created successfully" }
	    else
	      render json: { request_status: 500, request_message: "Store creation failed" }
	    end
	end

	def list_stores
		stores = JSON.parse(Store.all.select("id, name as value").to_json)
	    if stores.present?
	      render json: { stores: stores, request_status: 200, request_message: "" }
	    else
	      render json: { request_status: 500, request_message: "No records found" }
	    end
	end

	def fetch_store_balance_amount
		balance_amount = Sale.where("store_id = ?", params[:store][:store_id]).limit(1).order("id desc").select("balance_amount")
		if balance_amount.present?
			render json: { balance_amount: balance_amount, request_status: 200, request_message: "" }
		else
			render json: { request_status: 500, request_message: "" }
		end
	end

	def update
	end

	def delete
	end
end
