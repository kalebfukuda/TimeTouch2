class LineMessageProcessorJob < ApplicationJob
  queue_as :default

  def perform(line_user_id:, message:)
    contact = Contact.find_by(line_user_id: line_user_id)

    unless contact&.user
      Rails.logger.warn("[LineMessageProcessorJob] User não encontrado para line_user_id: #{line_user_id}")
      return
    end

    user = contact.user

    # Classifica a mensagem com IA
    classification = AiServices::MessageClassifierService.new(message).call
    Rails.logger.debug("[LineMessageProcessorJob] classification: #{classification.inspect}")

    case classification[:intent]
    when "FALTA"
      Registers::AbsenceRegistrarService.new(
        user:   user,
        date:   classification[:date],
        reason: classification[:reason]
      ).call

      ::LineSendMessageJob.perform_later(
        contact.id,
        "✅ Falta do dia #{classification[:date].strftime('%d/%m')} registrada. Fique bem! 🙏"
      )

    when "OUTRO"
      ::LineSendMessageJob.perform_later(
        contact.id,
        "Olá! No momento só consigo registrar faltas por aqui. Para outras dúvidas, fale com seu gestor. 😊"
      )
    end
  end
end
