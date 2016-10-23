require "./environment.cr"
require "./microfinance/*"

module Microfinance
  # TODO Put your code here
end

get "/" do |env|
  access_token = "Fre"
  render "public/index.ecr"
end

post "/oauth/callback" do |env|
end

Kemal.run
