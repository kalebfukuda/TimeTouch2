module Webhooks
  class LineController < ApplicationController
    skip_before_action :verify_authenticity_token

    def receive
      body      = request.body.read
      signature = request.headers['X-Line-Signature']

      unless valid_signature?(body, signature)
        return head :forbidden
      end

      parser = Line::Bot::V2::WebhookParser.new(ENV['LINE_CHANNEL_SECRET'])
      events = parser.parse(body, signature)

      events.each do |event|
        case event
        when Line::Bot::V2::WebhookParser::FollowEvent
          handle_follow(event)

        when Line::Bot::V2::WebhookParser::UnfollowEvent
          Contact.find_by(line_user_id: event.source.user_id)
                 &.update(opted_in: false)

        when Line::Bot::V2::WebhookParser::MessageEvent
          handle_message(event)
        end
      end

      head :ok
    end

    private

    def handle_follow(event)
      line_user_id = event.source.user_id
      contact = Contact.find_by(line_user_id: line_user_id)

      if contact
        contact.update(opted_in: true)
      else
        Contact.create!(line_user_id: line_user_id, opted_in: true)
        reply(event.reply_token, "Olá! Para vincular sua conta, envie seu email cadastrado.")
      end
    end

    def handle_message(event)
      line_user_id = event.source.user_id
      text         = event.message.text.to_s.strip
      contact      = Contact.find_by(line_user_id: line_user_id)

      return unless contact&.user_id.nil?

      user = User.find_by(email: text.downcase)

      if user
        if user.contact.present?
          reply(event.reply_token, "Esse email já está vinculado a outra conta.")
        else
          contact.update(user: user)
          nome = user.name || "você"
          reply(event.reply_token, "✅ Olá, #{nome}! Conta vinculada com sucesso.")
        end
      else
        reply(event.reply_token, "Email não encontrado. Tente novamente.")
      end
    end

    def reply(reply_token, text)
      client = Line::Bot::V2::MessagingApi::ApiClient.new(
        channel_access_token: ENV['LINE_CHANNEL_TOKEN']
      )
      api = Line::Bot::V2::MessagingApi::MessagingApiApi.new(client)
      api.reply_message(
        Line::Bot::V2::MessagingApi::ReplyMessageRequest.new(
          reply_token: reply_token,
          messages: [Line::Bot::V2::MessagingApi::TextMessage.new(text: text)]
        )
      )
    end

    def valid_signature?(body, signature)
      hash = OpenSSL::HMAC.digest('SHA256', ENV['LINE_CHANNEL_SECRET'], body)
      Base64.strict_encode64(hash) == signature
    end
  end
end
