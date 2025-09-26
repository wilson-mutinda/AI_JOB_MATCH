require 'jwt'
class JsonWebToken

  SECRET_KEY = ENV['SECRET_KEY']

  # encode user_id and exp
  def self.encode_token(user_id, flag, exp = 30.minutes.from_now)
    payload = {
      user_id: user_id,
      flag: flag,
      exp: exp.to_i
    }
    JWT.encode(payload, SECRET_KEY)
  end

  # decode access_token to get user_id
  def self.decode_token(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)

  rescue JWT::ExpiredSignature
    raise StandardError, 'Token Expired'

  rescue JWT::DecodeError
    raise StandardError, 'Invalid Token'
  end
end