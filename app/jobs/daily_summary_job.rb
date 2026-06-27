class DailySummaryJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    line_user_id = user.contact&.line_user_id
    return unless line_user_id

    # Busca os dados
    summary_data = Reports::DailySummaryQuery.new(company: user.profile.company, date: Date.today).call

    # Gera o texto com claude
    message = AiServices::DailySummaryService.new(summary_data).call

    # Envia a mensagem para o usuário
    LineSendMessageJob.perform_later(user.contact.id, message)
  end
end
