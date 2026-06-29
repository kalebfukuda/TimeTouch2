module AiServices
  class MessageClassifierService
    CLAUDE_API_URL = ENV.fetch("ANTHROPIC_API_URL", "https://api.anthropic.com/v1/messages").freeze
    CLAUDE_MODEL   = ENV.fetch("ANTHROPIC_MODEL", "claude-haiku-4-5-20251001").freeze
    MAX_TOKENS     = 150

    def initialize(message)
      @message = message
    end

    def call
      response = ::Faraday.post(CLAUDE_API_URL) do |req|
        req.headers["x-api-key"]         = ENV.fetch("ANTHROPIC_API_KEY")
        req.headers["anthropic-version"] = "2023-06-01"
        req.headers["Content-Type"]      = "application/json"
        req.body                         = payload.to_json
      end

      parse_response(response)
    rescue Faraday::Error => e
      Rails.logger.error("[Ai::MessageClassifierService] Erro: #{e.message}")
      fallback
    end

    private

    def payload
      {
        model:      CLAUDE_MODEL,
        max_tokens: MAX_TOKENS,
        messages:   [{ role: "user", content: prompt }]
      }
    end

    def prompt
      <<~PROMPT
        Classifique a mensagem de um funcionário de construção civil.

        CATEGORIAS:
        - FALTA: funcionário avisa que não vai trabalhar

        REGRAS:
        - Responda APENAS com JSON válido, sem explicação
        - Para datas relativas, considere hoje como #{Date.today}
        - Se não for FALTA, use intent: "OUTRO"

        FORMATO:
        {"intent": "FALTA", "date": "2026-06-28", "reason": "doença"}
        {"intent": "OUTRO", "date": null, "reason": null}

        MENSAGEM: "#{@message}"
      PROMPT
    end

    def parse_response(response)
      parsed = JSON.parse(response.body)
      text   = parsed.dig("content", 0, "text").to_s.strip

      result = JSON.parse(text, symbolize_names: true)
      result[:date] = Date.parse(result[:date]) if result[:date]
      result
    rescue JSON::ParserError => e
      Rails.logger.error("[Ai::MessageClassifierService] JSON inválido: #{e.message}")
      fallback
    end

    def fallback
      { intent: "OUTRO", date: nil, reason: nil }
    end
  end
end
