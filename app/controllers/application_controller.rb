class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token
  class AuthenticationError < StandardError; end

  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  rescue_from AuthenticationError, with: :authentication_error
  rescue_from JWT::DecodeError, with: :unauthorized

  def entity_with_same_name_exist_error(name)
    render json: { name: ["#{name} with same name exists."] }, status: :unprocessable_entity
  end

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
    render json: { credential_invalid: ["Invalid username or password" ]}, status: :unauthorized
  end

  def parameter_missing(e)
    render json: { parameter_invalid: ["#{e.param} is missing or value is empty"] }, status: :unprocessable_entity
  end

  def unauthorized
    render json: { unauthorized: ['User not Authorized'] }, status: :unauthorized
  end
end
