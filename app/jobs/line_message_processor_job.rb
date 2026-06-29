class LineMessageProcessorJob < ApplicationJob
  queue_as :default

  def perform(line_user_id:, message:)
    # Busca o funcionário pelo line_user_id
    contact = Contact.find_by(line_user_id: line_user_id)

    unless contact
      Rails.logger.warn("[LineMessageProcessorJob] Contact não encontrado: #{line_user_id}")
      return
    end

    user = contact.user

    # Classifica a mensagem com IA
    classification = Ai::MessageClassifierService.new(message).call

    # Age baseado na classificação
    case classification[:intent]
    when "FALTA"
      Registers::AbsenceRegisterService.new(
        user:   user,
        date:   classification[:date],
        note: classification[:reason]
      ).call

      LineSendMessageJob.perform_later(
        contact.id,
        "✅ Entendido! Sua falta do dia #{classification[:date].strftime('%d/%m')} foi registrada. Fique bem! 🙏"
      )

    when "OUTRO"
      LineSendMessageJob.perform_later(
        contact.id,
        "Olá! No momento só consigo registrar faltas por aqui. Para outras dúvidas, fale com seu gestor. 😊"
      )
    end
  end
end
