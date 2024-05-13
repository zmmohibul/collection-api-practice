class AuthenticationTokenService
  HMAC_SECRET = "my$ecretkin$token"
  ALGORITHM_TYPE = "HS256"
  def self.encode(user)
    payload = { user_id: user.id, username: user.username }

    JWT.encode payload, HMAC_SECRET, ALGORITHM_TYPE
  end

  def self.decode(token)
    decoded_token = JWT.decode(token, HMAC_SECRET, true, { algorithm: ALGORITHM_TYPE })
    decoded_token[0]
  end
end