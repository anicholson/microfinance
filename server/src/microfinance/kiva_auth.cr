require "http/client"
require "oauth"

class KivaAuthorizer
  @request_token : Symbol | OAuth::RequestToken

  def initialize(@config : Config::Configuration)
    @consumer1 = OAuth::Consumer.new(config.request_token_base, config.client_id, config.client_secret, 443, "https", "/oauth/request_token", "/oauth/authorize", "/oauth/access_token.json")
    @consumer2 = OAuth::Consumer.new(config.authorization_base, config.client_id, config.client_secret, 443, "https", "", "/oauth/authorize", "")
    @request_token = :unset
  end

  private getter config, consumer1, consumer2

  def request_token : OAuth::RequestToken
    if @request_token == :unset
      Kemal.config.logger.write("Getting token the first time\n")
      @request_token = consumer1.get_request_token(config.oauth_callback)
    else
      Kemal.config.logger.write("WE HAVE A REQUEST TOKEN\n")
      @request_token.as(OAuth::RequestToken)
    end
  end

  def authorize_kiva_api_url
    base_uri = URI.parse(consumer2.get_authorize_uri(request_token, config.oauth_callback))

    params = HTTP::Params.parse(base_uri.query.as(String))
    params.add("response_type", "code")
    params.add("client_id", config.client_id)

    base_uri.query = params.to_s

    base_uri.to_s
  end
end
