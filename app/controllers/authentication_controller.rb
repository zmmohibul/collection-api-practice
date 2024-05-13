class AuthenticationController < ApplicationController
  def register
    user = User.new(username: username_param, password: password_param)

    if user.save
      return render json: user_json(user), status: :created
    end

    render json: user.errors, status: :unprocessable_entity
  end

  def login
    user = User.find_by(username: username_param)
    if user == nil || user.authenticate(password_param) == false
      raise AuthenticationError
    end

    render json: user_json(user), status: :ok
  end

  private
  def username_param
    params.require(:username)
  end

  def password_param
    params.require(:password)
  end

  def user_json(user)
    { id: user.id, username: user.username, token: AuthenticationTokenService.encode(user) }
  end
end