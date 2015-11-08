class ApplicationController < ActionController::Base
  PRIMARY_HOST = ENV["PRIMARY_HOST"].try(:freeze)
  REDIRECT_TO_PRIMARY_HOST = lambda {
    redirect_env = Rails.env.production? || Rails.env.development?
    redirect_env && PRIMARY_HOST.present?
  }.call

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_screenshot
  before_action :ensure_primary_host

  def new_session_path(scope)
    root_path
  end

  def after_sign_in_path_for(resource)
    projects_path
  end

  protected

  def ensure_primary_host
    return unless REDIRECT_TO_PRIMARY_HOST && PRIMARY_HOST != request.host
    logger.warn {
      "Redirect host because it was #{request.host.inspect}, " \
      "and we want #{PRIMARY_HOST.inspect}"
    }
    redirect_to url_for(params.merge(host: PRIMARY_HOST))
  end

  def pm
    @pm ||= ProjectManager.new(current_user)
  end

  def check_screenshot
    unless params[:screenshot].blank?
      redirect_to "/screenshot.html"
    end
  end
end
