module Entities

  class Message < Grape::Entity
    expose :queue_id, documentation: { type: 'integer', desc: 'Queue ID id >= offset parameter', required: true }
    expose :msg_id, documentation: { type: 'string', desc: '6 digits, day, hour, minutes', required: true }
    expose :from, documentation: { type: 'string', desc: 'AFTN address', required: true }
    expose :to, documentation: { type: 'string', is_array: true, desc: 'AFTN addresses', required: true }
    expose :priority, documentation: { type: 'integer', desc: 'AFTN 1=КК, 2=ГГ, 3=ФФ, 4=ДД, 5=СС', values: 1..5 }
    expose :body, documentation: { type: 'string', required: true }
    expose :raw_message, documentation: { type: 'string', required: true }, if: ->(instance, opts){ instance[:raw_message] }
    expose :created_at
    expose :updated_on
  end

  class Response < Grape::Entity
    expose :messages, using: Message, documentation: { is_array: true, required: true }
    expose :count, documentation: { type: 'integer', desc: 'Total message count', required: true }
  end

  class Status < Grape::Entity
    expose :message, documentation: { type: 'string', desc: 'Status message', required: true }
  end
end

