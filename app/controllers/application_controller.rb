class ApplicationController < ActionController::API
  class AuthenticationError < StandardError; end

  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from AuthenticationError, with: :handle_authentication_error

  private
  def handle_authentication_error
    render json: { error: "Invalid username or password" }, status: :unauthorized
  end

  def parameter_missing(e)
    render json: { error: "Field #{e.param} is missing or value is empty" }, status: :unprocessable_entity
  end
end
