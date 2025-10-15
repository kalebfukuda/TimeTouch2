class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  before_action :authenticate_user!, only: [:main]

  def home
  end

  def main
    @register = Register.new
    @registers = Register.where(profile: current_user.profiles.first).order(date: :desc)
    @schedule = Schedule.find_by(date: Date.current, profile: current_user.profiles.first)
  end
end
