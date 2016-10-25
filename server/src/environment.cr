require "kemal"

require "./microfinance/kiva_auth.cr"



  module Config
    struct Configuration
      property api_base, request_token_base, access_token_uri, client_id, client_secret, oauth_callback, authorization_base

      def initialize(@api_base : URI, @authorization_base : String, @request_token_base : String,  @access_token_uri : URI, @client_id : String, @client_secret : String, @oauth_callback : String)
      end
    end

    def self.oauth_config : Configuration
      @@oauth_config ||= Configuration.new(
        URI.new("https://api.kivaws.org"),
        "www.kiva.org",
        "api.kivaws.org",
        URI.new("https://api.kivaws.org/oauth/access_token"),
        "com.dotnich.microfinance",
        "97nfvM-a2b5PvOTEDrAYNVNEPSONkNQs",
        "oob"
      )
    end
  end
