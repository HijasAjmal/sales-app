class Api::V1::UsersController < ApplicationController
	skip_before_action :authenticate_request, :only => [:login]

	def login
	   command = AuthenticateUser.call(params[:email], params[:password])

	   if command.success?
	     render json: { auth_token: command.result, request_status: 200, request_message: "Login successfull" }
	   else
	     render json: { error: command.errors, request_status: 500, request_message: "Login failed" }, status: :unauthorized
	   end
	end

	def create_new_user
		user = User.new()
		encrypted_password, salt = User.encrypt_user_password(params[:password])
		user.first_name = params[:first_name]
		user.middle_name = params[:middle_name]
		user.last_name = params[:last_name]
		user.email = params[:email]
		user.password_digest = encrypted_password
		user.salt = salt
		user.phone_number = params[:phone_number]
		if user.save
	     render json: { request_status: 200, request_message: "User created successfully" }
	   	else
	     render json: { request_status: 500, request_message: "User creation failed" }
	   	end
	end

	def list_users
		users = JSON.parse(User.all.select("id, CONCAT_WS(' ', first_name, middle_name, last_name) AS name").to_json).each{|f| f['key'] = f["id"]}
		render json: { users: users, request_status: 200, request_message: "" }
	end

	def show_user_profile
		user = User.select("id, CONCAT_WS(' ', first_name, middle_name, last_name) as name, phone_number, email").where(['id = ?', params[:user][:userId]])
		render json: { user: user, request_status: 200, request_message: "" }
	end

	def edit_user
		user = User.select('id, first_name, middle_name, last_name, email, phone_number').where(id: params[:user][:id])
		if user.present?
			render json: { user: user, request_status: 200, request_message: "" }
		else
			render json: { request_status: 500, request_message: "User record does not exist" }
		end
	end

end
