require 'line/bot'

class LineSendMessageJob < ApplicationJob
  queue_as :broadcasts
  retry_on StandardError, attempts: 3, wait: :exponentially_longer

  def perform(contact_id, message_text)
    contact = Contact.find(contact_id)

    api = Line::Bot::V2::MessagingApi::ApiClient.new(
      channel_access_token: ENV['LINE_CHANNEL_TOKEN']
    )

    api.push_message(
      push_message_request: Line::Bot::V2::MessagingApi::PushMessageRequest.new(
        to: contact.line_user_id,
        messages: [Line::Bot::V2::MessagingApi::TextMessage.new(text: message_text)]
      )
    )
  end
end
