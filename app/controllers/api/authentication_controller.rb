class Api::AuthenticationController < ApplicationController
  before_action :authorize, only: [:authenticated, :admin_authenticated]
  before_action :authorize_admin, only: [:admin_authenticated]

  def register
    @current_user = User.new(username: username_param, password: password_param)
    return render(json: @current_user.errors, status: :unprocessable_entity) unless @current_user.save
    render(json: user_json, status: :created)
  end

  def login
    @current_user = User.find_by(username: username_param)
    raise AuthenticationError unless authenticate_user
    render json: user_json, status: :ok
  end

  def authenticated
    render json: user_json, status: :ok
  end

  def admin_authenticated
    render json: user_json, status: :ok
  end

  private
  def username_param
    params.require(:username)
  end

  def password_param
    params.require(:password)
  end

  def authenticate_user
    @current_user && @current_user.authenticate(password_param)
  end

  def user_json
    {
      id: @current_user.id,
      username: @current_user.username,
      role: @current_user.role,
      token: AuthenticationTokenService.encode(@current_user)
    }
  end
end