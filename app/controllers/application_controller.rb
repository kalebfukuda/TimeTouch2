class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  protected

  def after_sign_in_path_for(resource)
    main_path # 👈 change this to wherever you want
  end
end
