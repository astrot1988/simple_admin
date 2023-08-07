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
