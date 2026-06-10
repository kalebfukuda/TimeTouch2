module Line
  class BroadcastService
    def self.send_to_all(message_text)
      ::Contact.opted_in.where.not(user_id: nil).find_each do |contact|
        ::LineSendMessageJob.perform_later(contact.id, message_text)
      end
    end

    def self.send_to_all_personalized(message_template)
      ::Contact.opted_in.where.not(user_id: nil).find_each do |contact|
        message = message_template.gsub('{{nome}}', contact.user_name || "você")
        ::LineSendMessageJob.perform_later(contact.id, message)
      end
    end

    def self.send_to_user(user, message_text)
      contact = user.contact
      return unless contact&.opted_in? && contact.line_user_id.present?
      ::LineSendMessageJob.perform_later(contact.id, message_text)
    end
  end
end
