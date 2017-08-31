require 'httparty'

class Kele
  include HTTParty

  def initialize(email, password)
    @base_uri = 'https://www.bloc.io/api/v1'
    response = self.class.post("#{@base_uri}/sessions", body: {"email": email, "password": password})
    raise response["message"] if response.code != 200
    @auth_token = response["auth_token"]
  end
end
