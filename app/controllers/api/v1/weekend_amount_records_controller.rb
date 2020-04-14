class Api::V1::WeekendAmountRecordsController < ApplicationController
  def index
  end

  def create
  end

  def update
  end

  def destroy
  end

  def list_records
    records_data = []
    weekend_amount_records = JSON.parse(WeekendAmountRecord.select("id, sold_date, amount_calculated").where("amount_calculated = false").to_json)
    weekend_amount_records.each do |record|
      records_data << [record.values[1].to_s, record.values[2].to_s, record.values[0].to_s]
    end
    if records_data.present?
      render json: { records_data: records_data, request_status: 200, request_message: "" }
    else
      render json: { request_status: 500, request_message: "No records found" }
    end
  end

  def update_weekend_records

  end
end
