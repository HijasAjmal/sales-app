class Api::V1::ReportsController < ApplicationController

	def generate_report
		if params[:report][:value] == 0
			reports = Purchase.generate_report(params[:report][:start_date], params[:report][:end_date])
		elsif params[:report][:value] == 1
			reports = Sale.generate_report(params[:report][:start_date], params[:report][:end_date])
		elsif params[:report][:value] == 2
			reports = FinanceTransaction.generate_report(params[:report][:start_date], params[:report][:end_date])
		end
		if reports.present?
			render json: { reports: reports, request_status: 200, request_message: "" }
		else
			render json: { request_status: 500, request_message: "Report generation faild" }
		end
	end
end
