class Api::AuthenticationController < ApplicationController
  before_action :authorize, only: [:authenticated, :admin_authenticated]
  before_action :authorize_admin, only: [:admin_authenticated]

  def register
    user = User.new(username: username_param, password: password_param)
    return render(json: user.errors, status: :unprocessable_entity) unless user.save
    render(json: user_json(user), status: :created)
  end

  def login
    user = User.find_by(username: username_param)
    raise AuthenticationError unless authenticate(user)
    render json: user_json(user), status: :ok
  end

  def authenticated
    render json: user_json(@user), status: :ok
  end

  def admin_authenticated
    render json: user_json(@user), status: :ok
  end

  private
  def username_param
    params.require(:username)
  end

  def password_param
    params.require(:password)
  end

  def authenticate(user)
    user && user.authenticate(password_param)
  end

  def user_json(user)
    {
      id: user.id,
      username: user.username,
      role: user.role,
      token: AuthenticationTokenService.encode(user)
    }
  end
end