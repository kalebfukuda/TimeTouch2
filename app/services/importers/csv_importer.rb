require "csv"

module Importers
  class CsvImporter
    def initialize(file_path, company_id = nil)
      @file_path = file_path
      @company_id = company_id || 2 # fallback
    end

    def gembaImporter
      CSV.foreach(@file_path, headers: true) do |row|
        gemba_attrs = {
          name:         row["name"]&.strip,
          code:         row["code"]&.strip,
          company_id:   @company_id,
        }
        gemba = Gemba.find_or_initialize_by(name: gemba_attrs[:name], company_id: @company_id)

        if gemba.present?
          unless gemba.update(gemba_attrs)
            Rails.logger.error "Failed to update gemba for #{gemba_attrs[:name]}: #{gemba.errors.full_messages.join(", ")}"
          end
        else
          gemba = Gemba.new(gemba_attrs)
          unless gemba.save
            Rails.logger.error "Failed to create gemba for #{gemba_attrs[:name]}: #{gemba.errors.full_messages.join(", ")}"
          end
        end
      end
    end

    def userImporter
      CSV.foreach(@file_path, headers: true) do |row|
        email = row["email"]&.strip
        password = row["password"]&.strip
        next if email.blank? || password.blank?

        # Create or find user
        user = User.find_or_initialize_by(email: email)
        user.password = password
        begin
          user.save!
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.error "Failed to save user #{email}: #{e.record.errors.full_messages.join(", ")}"
          next
        end

        # Create or update profile
        profile_attrs = {
          name:      row["name"]&.strip,
          can_drive: parse_boolean(row["can_drive"]),
          role_id:   row["role"]&.to_i,
          salary:    row["salary"]&.to_f,
          company_id: @company_id
        }

        if user.profiles.present?
          unless user.profile.update(profile_attrs)
            Rails.logger.error "Failed to update profile for #{email}: #{user.profile.errors.full_messages.join(", ")}"
          end
        else
          profile = user.build_profile(profile_attrs)
          unless profile.save
            Rails.logger.error "Failed to create profile for #{email}: #{profile.errors.full_messages.join(", ")}"
          end
        end
      end
    end

    private

    def parse_boolean(value)
      value.to_s.strip.downcase == "true"
    end
  end
end
