require_relative '../aftn/message'
require_relative '../database/aftn_message'
require_relative 'entities'

class SendMessage < Grape::API
  desc 'Send AFTN message',
       success: { model: Entities::Status, message: 'Status', required: true }
  params do
    requires :body,     type: String, desc: 'AFTN message body'#, values: ->(v) { v.size < 1800 - xx registers - \r\n }
    requires :to,       type: Array[String], desc: 'Array of addresses'#, values: ->(v) { v.is_a?(Array) && v.map(&:size).uniq == [8] && v.size < 8 }
    optional :priority, type: String, desc: 'KK | GG | FF | DD | SS'#, values: %w[KK GG FF DD SS]
    optional :msg_id,   type: String, desc: '6 digits, day, hour, minutes'#, regexp: /^\d{6}$/
    optional :from,     type: String, desc: 'Source addresses'#, values: ->(v) { v.size == 8 }
    optional :translit2eng, type: Boolean, default: false, desc: 'Transliterate to EN body text'
  end
  post '/sendMessage' do
    task = AftnConnector.send_message body: params[:body],
                                           to: params[:to],
                                           priority: params[:priority],
                                           msg_id: params[:msg_id],
                                           from: params[:from],
                                           translit2eng: params[:translit2eng]
    task.wait
    present message: 'successful', with: Entities::Status
  end
end
