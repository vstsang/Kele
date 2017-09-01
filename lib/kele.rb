require 'httparty'
require 'json'

class Kele
  include HTTParty
  @@base_uri = 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    response = self.class.post("#{@@base_uri}/sessions", body: {"email": email, "password": password})
    raise response["message"] if response.code != 200
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get("#{@@base_uri}/users/me", headers: { "authorization" => @auth_token })
    raise response["message"] if response.code != 200
    user_json = JSON.parse(response.body)
  end
end
