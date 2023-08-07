require_relative '../aftn/message'
require_relative '../database/aftn_message'
require_relative 'entities'

class GetMessages < Grape::API
  desc 'Get new messages',
       success: { model: Entities::Response, message: 'New messages' }
  params do
    optional :offset,   type: Integer, default: 0, desc: 'The lowest message id to send'
    optional :limit,    type: Integer, default: 10, values: 1..100
    optional :timeout,  type: Integer, desc: 'Long poling timeout', default: 0, values: 0..600
    optional :raw_message, type: Boolean, default: false, desc: 'Add raw telegram message'
    optional :transliterate, type: Boolean, default: false, desc: 'Transliterate to EN body text'
  end

  get 'getMessages' do
    set = DB_AFTN_Message.where(direction: 'received', service: 0)
                         .where(Sequel.lit("message_counter >= #{params[:offset]}"))
    count = DB_LISTENER.acquire_db { set.count }

    # Long polling
    AftnConnector.wait_for :new_message_db, params[:timeout] if count.zero? && params[:timeout] > 0

    response = DB_LISTENER.acquire_db do
      {
        messages: set.limit(params[:limit]).all,
        count:    set.count
      }
    end

    response[:messages].map! do |msg|
      {
        queue_id: msg.message_counter,
        msg_id: msg.telegram.id,
        from: msg.telegram.from,
        to: msg.telegram.to,
        priority: msg.telegram.priority,
        body: msg.telegram.text,
        created_at: msg.created_at&.utc,
        updated_on: msg.updated_on&.utc
      }.tap { |m|
        m[:raw_message] = msg.message if params[:raw_message]
        m[:body] = transliterate_msg(m[:body]) if params[:transliterate]
      }
    end

    present response, with: Entities::Response
  end
end
