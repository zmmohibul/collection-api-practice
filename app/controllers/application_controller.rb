class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token
  class AuthenticationError < StandardError; end

  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  rescue_from AuthenticationError, with: :authentication_error
  rescue_from JWT::DecodeError, with: :unauthorized


  private
  def current_user
    if decoded_user_token
      user_id = decoded_user_token['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def decoded_user_token
    token, _options = token_and_options(request)
    AuthenticationTokenService.decode(token) if token
  end

  def authorize
    unauthorized unless !!current_user
  end

  def authorize_admin
    unauthorized unless @user.admin?
  end

  def authentication_error
    render json: { error: "Invalid username or password" }, status: :unauthorized
  end

  def parameter_missing(e)
    render json: { error: "Field #{e.param} is missing or value is empty" }, status: :unprocessable_entity
  end

  def unauthorized
    render json: { error: 'Not Authorized' }, status: :unauthorized
  end
end
