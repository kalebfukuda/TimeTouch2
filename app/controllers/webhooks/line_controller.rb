module Webhooks
  class LineController < ApplicationController
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!

    def receive
      body      = request.body.read
      signature = request.headers['X-Line-Signature']

      parser = Line::Bot::V2::WebhookParser.new(channel_secret: ENV['LINE_CHANNEL_SECRET'])

      unless parser.verify_signature(body: body, signature: signature)
        return head :forbidden
      end

      events = parser.parse(body: body, signature: signature)

      events.each do |event|
        case event
        when Line::Bot::V2::Webhook::FollowEvent
          handle_follow(event)

        when Line::Bot::V2::Webhook::UnfollowEvent
          Contact.find_by(line_user_id: event.source.user_id)
                &.update(opted_in: false)

        when Line::Bot::V2::Webhook::MessageEvent
          handle_message(event) if event.message.is_a?(Line::Bot::V2::Webhook::TextMessageContent)
        end
      end

      head :ok
    end

    private

    def handle_follow(event)
      line_user_id = event['source']['userId']
      contact      = Contact.find_by(line_user_id: line_user_id)

      if contact
        contact.update(opted_in: true)
      else
        Contact.create!(line_user_id: line_user_id, opted_in: true)
        reply(event['replyToken'], "Olá! Para vincular sua conta, envie seu email cadastrado.")
      end
    end

    def try_link_by_token(text, line_user_id, reply_token)
      contact = Contact.find_by(invitation_token: text)
      return false unless contact&.invitation_valid?

      contact.update(
        line_user_id:          line_user_id,
        opted_in:              true,
        invitation_token:      nil,
        invitation_expires_at: nil
      )

      nome = contact.user&.name || "você"
      reply(reply_token, "✅ Olá, #{nome}! Conta vinculada com sucesso. 🎉")
      true
    end

    def handle_message(event)
      line_user_id = event.source.user_id
      text         = event.message.text.to_s.strip

      # Tenta vincular por token primeiro
      if try_link_by_token(text, line_user_id, event.reply_token)
        return
      end

      contact      = Contact.find_by(line_user_id: line_user_id)
      return unless contact

      if contact.user_id.nil?
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

      else
        ::LineMessageProcessorJob.perform_later(
          line_user_id: line_user_id,
          message:      text
        )
      end
    end

    def reply(reply_token, text)
      api = Line::Bot::V2::MessagingApi::ApiClient.new(
        channel_access_token: ENV['LINE_CHANNEL_TOKEN']
      )

      api.reply_message(
        reply_message_request: Line::Bot::V2::MessagingApi::ReplyMessageRequest.new(
          reply_token: reply_token,
          messages:    [Line::Bot::V2::MessagingApi::TextMessage.new(text: text)]
        )
      )
    end
  end
end
