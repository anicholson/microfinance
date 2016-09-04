require "kemal"

require "./microfinance/*"

module Microfinance
  # TODO Put your code here
end


get "/" do |env|
  render "public/index.ecr"
end

Kemal.run
