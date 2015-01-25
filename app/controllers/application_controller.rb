class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  skip_before_filter :verify_authenticity_token, :if => :check_method

  before_action :set_locale, :check_env

  add_flash_types :success, :info, :warning, :danger

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

private

  def check_method
    request.format == :json
  end

  def check_env
    @is_production_env = ( Rails.env == 'production' )
  end

end
