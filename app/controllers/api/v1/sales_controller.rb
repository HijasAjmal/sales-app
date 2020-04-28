class Api::V1::SalesController < ApplicationController
    def index
    end

    def list_sales
        sales = JSON.parse(Sale.all.joins(:store).where("sales.selling_date = ? ", params[:sale][:selling_date].to_date).
          select("sales.id, stores.name, sales.selling_date, sales.total_box_count, sales.total_weight, sales.empty_box_weight, sales.item_weight,
            sales.rate, sales.expected_amount, sales.paid_amount, sales.balance_amount").to_json).each{|f| f['key'] = f["id"]}
        if sales.present?
          render json: { sales: sales, request_status: 200, request_message: "" }
        else
          render json: { request_status: 500, request_message: "No records found" }
        end
    end
  
    def create
        sale = Sale.create(params[:sale].permit(:store_id, :selling_date, :total_box_count, :total_weight, :empty_box_weight, :item_weight,
            :rate, :expected_amount, :paid_amount, :balance_amount))
        sale.update(:user_id => @current_user.id)
        if sale.present?
          render json: { request_status: 200, request_message: "Sale record created successfully" }
        else
          render json: { request_status: 500, request_message: "Sale record creation failed" }
        end
    end
  
    def update
    end
  
    def destroy
        sale_record = Sale.find_by_id(params[:id])
        if sale_record.destroy
            render json: { request_status: 200, request_message: "Sale record deleted successfully" }
        else
            render json: { request_status: 500, request_message: "Sale record deletion failed" }
        end
    end
end
