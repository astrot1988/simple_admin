require 'grape'
require 'grape-swagger'
require 'grape-swagger-entity'
require 'grape_logging'

require_relative 'get_messages'
require_relative 'send_message'

class AftnRestApi < Grape::API
  version 'v1', using: :path, vendor: 'monitorsoft'
  use GrapeLogging::Middleware::RequestLogger, logger: LOGGER_GRAPE if REST_LOGGER

  # rescue_from :all
  format :json
  content_type :json, 'application/json'

  namespace :api do
    mount ::GetMessages
    mount ::SendMessage
  end

  add_swagger_documentation \
    info: { title: 'AFTN Channel API' }, hide_documentation_path: true,
    mount_path: '/swagger.json', markdown: false, doc_version: '0.1.0'
    # http://localhost:3000/swagger.json
end
