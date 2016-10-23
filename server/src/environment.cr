require "kemal"

require "./microfinance/kiva_auth.cr"


module Microfinance
  module Config
    def oauth_config
      @oauth_config ||= case ENV["environment"]
                        when "development"
                          Configuration.new(
                          )
                        end
    end
  end
end
