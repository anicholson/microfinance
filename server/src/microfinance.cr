require "./environment.cr"
require "./microfinance/*"


def kiva_auth
  KivaAuthorizer.new(Config.oauth_config)
end

def layout
  "public/layout.ecr"
end


get "/authorize/step/1" do |env|
  begin
    redirect = kiva_auth.authorize_kiva_api_url
    env.redirect redirect
  rescue e : OAuth::Error
    e.message
  end
end

get "/authorize/step/2" do |env|
  render "public/authorize_step_2.ecr", "public/layout.ecr"
end

post "/authorize/step/2" do |env|
  env.response.print env.params.body, "public/layout.ecr"
end

get "/" do |env|
  access_token = "Fre"
  render "public/index.ecr", "public/layout.ecr"
end

post "/oauth/callback" do |env|
end



Kemal.run
