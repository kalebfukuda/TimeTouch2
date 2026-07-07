module AiServices
  class DailySummaryService
    CLAUDE_API_URL = ENV.fetch('ANTHROPIC_API_URL', 'https://api.anthropic.com/v1/messages').freeze
    CLAUDE_MODEL = ENV.fetch('ANTHROPIC_MODEL', 'claude-haiku-4-5-20251001').freeze
    MAX_TOKENS = 300

    def initialize(summary_data)
      @data = summary_data
    end

    def call
      response = ::Faraday.post(CLAUDE_API_URL) do |req|
        req.headers["x-api-key"] = ENV.fetch('ANTHROPIC_API_KEY')
        req.headers['Content-Type'] = 'application/json'
        req.headers["anthropic-version"] = "2023-06-01"
        req.body = payload.to_json
      end

      parse_response(response)
    rescue Faraday::Error => e
      Rails.logger.error("Error calling Claude API: #{e.message}")
      fallback_message
    end

    private

    def payload
      {
        model: CLAUDE_MODEL,
        max_tokens: MAX_TOKENS,
        messages: [{ role: "user", content: prompt }]
      }
    end

    def prompt
      # TODO: trocar a linguagem baseada no idioma do usuário
      <<~PROMPT
        Você é um assistente de gestão de equipe para empresas de construção.
        Com base nos dados abaixo, gere um resumo executivo curto para o
        gestor receber via LINE.

        REGRAS:
        - Maximo 5 linhas
        - Use emojis para facilitar a leitura
        - Destaque apenas o que precisa de atenção do gestor
        - Responda em português

        DADOS DO DIA #{formatted_date}:
        - Funcionários agendados: #{@data[:scheduled]}
        - Presentes: #{@data[:present]}
        - Ausentes: #{@data[:absent]}
        - Turno da manhã: #{@data[:morning_count]}
        - Turno da noite: #{@data[:night_count]}
      PROMPT
    end

    def parse_response(response)
      parsed = JSON.parse(response.body)

      if response.status == 200
        parsed.dig("content", 0, "text")
      else
        Rails.logger.error("Claude API error: #{parsed['error']}")
        fallback_message
      end
    end

    def fallback_message
      <<~MSG
        Desculpe, ocorreu um erro ao gerar o resumo. Por favor, tente novamente.
      MSG
    end

    def formatted_date
      @data[:date].strftime("%d/%m")
    end
  end
end
