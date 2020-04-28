class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    User.current = @current_user # assigning the current session
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end
