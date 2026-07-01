module Registers
  class AbsenceRegisterService
    def initialize(user:, date:, note: nil )
      @user   = user
      @date   = date
      @note = note
    end

    def call
      # Busca register existente ou cria novo
      register = Register.find_or_initialize_by(
        profile: @user.profile,
        date:    @date
      )

      register.assign_attributes(
        status_register: :absent,
        absence_reason:  @note,
        gemba_id:        find_gemba
      )

      if register.save
        Rails.logger.info("[Registers::AbsenceRegisterService] Falta registrada — user: #{@user.id}, date: #{@date}")
        true
      else
        Rails.logger.error("[Registers::AbsenceRegisterService] Erro ao salvar: #{register.errors.full_messages}")
        false
      end
    end

    private

    def find_gemba
      @user.profile.schedules.find_by(date: @date)&.gemba_id ||
        @user.profile.registers.order(created_at: :desc).pick(:gemba_id)
    end
  end
end
