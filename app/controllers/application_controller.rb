class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token
  class AuthenticationError < StandardError; end

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordNotUnique, with: :record_not_unique

  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  rescue_from AuthenticationError, with: :authentication_error
  rescue_from JWT::DecodeError, with: :unauthorized

  rescue_from ArgumentError, with: :argument_error

  def entity_with_same_name_exist(name)
    render json: { name: ["#{name} with same name exists."] }, status: :unprocessable_entity
  end

  private
  def current_user
    if decoded_user_token
      user_id = decoded_user_token['user_id']
      @current_user = User.find_by(id: user_id)
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
    unauthorized unless @current_user.admin?
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

  def forbidden
    render json: { forbidden: ['Sorry, you are not allowed to do that.'] }, status: :forbidden
  end

  def resource_belongs_to_current_user(resource)
    resource.user.id == @current_user.id || @current_user.admin?
  end

  def record_not_found(e)
    render json: { not_found: [e] }, status: :not_found
  end

  def record_not_unique(e)
    strings_in_error_message = e.to_s.split(" ")
    index_of_word_key = strings_in_error_message.index("Key")
    message = strings_in_error_message.slice(index_of_word_key + 1, 10).join(" ")
    render json: { not_unique: [message] }, status: :unprocessable_entity
  end

  def argument_error(e)
    render json: { "invalid_value": [e] }, status: :unprocessable_entity
  end
end
