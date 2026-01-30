class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :set_locale

  private

  def set_locale
    I18n.locale =
      params[:locale] ||
      current_user&.profile&.locale ||
      I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  protected

  def after_sign_in_path_for(resource)
    main_path
  end
end
