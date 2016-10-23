require "http/client"

struct Configuration
  property redirect_uri, request_token_path, access_token_ath, lender_authorization_uri, base, client_id, client_secret

  def initialize(@base : URI, @redirect_uri : String, @request_token_path : String, @access_token_path : String, @lender_authorization_uri : String?, client_id : String, client_secret : String)
  end
end

class KivaAuth(O)
  def initialize(@config : Configuration)
    @client = O.new(config.base.host, config.client_id, config.client_secret)
  end

  private getter client, config

  def registration_url
    client.get_authorize_uri
  end
end
