class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def main
    @register = Register.new
    @registers = Register.where(profile: current_user.profiles.first).order(date: :desc)
  end
end
