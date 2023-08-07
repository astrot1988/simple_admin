require 'grape'
require 'rack/handler/falcon'
require 'async'

class API < Grape::API
  get '/' do
    { hello: 'world' }
  end
end

# run Rack::Cascade.new [ API ]

Async do
  Rack::Handler::Falcon.run API do |s| #, Port: HTTP_PORT, Host: HTTP_HOST
    puts "Server started: #{s}"
  end
end


# #!/usr/bin/env ruby
# require_relative 'config.rb'
# require_relative 'logging'
# require_relative 'aftn/aftn'
# require_relative 'database/aftn_message'
# require_relative 'rest_api/rest_api'
# require 'rack/handler/falcon'
#
# Async do
#   AftnConnector.run if START_CONNECTOR
#   StubCKServer.new.run port: STUB_CKS_PORT, aftn_addr: STUB_CKS_HOST, channel_name: STUB_CKS_CHANNEL if START_STUB_CKS
#
#   # Rack::Handler::Falcon.run AftnRestApi, Port: REST_API_PORT, Host: REST_API_HOST if START_REST_API
#   Rack::Handler::Falcon.run Rack::Builder.new {
#     run AftnRestApi.new
#     use Rack::Static, urls: [''], root: "#{__dir__}/public/", index: 'index.html', cascade: true if SWAGGER_UI
#   }, Port: REST_API_PORT, Host: REST_API_HOST if START_REST_API
# end
