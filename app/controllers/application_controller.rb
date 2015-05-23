class ApplicationController < ActionController::Base

  before_filter :require_login

  layout :set_layout

  helper_method :mobile_device?

  protected

  def not_authenticated
    respond_to do |format|
      format.html { redirect_to login_path }
      format.json { render status: :forbidden, json: { redirect: login_path, error: I18n.t("user.access_denied") } }
    end
  end

  def set_layout
    mobile_device? ? "mobile" : "application"
  end

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
    # true
  end

  def render_markup_if_html
    render(nothing: true, layout: true) if params[:format].nil? || params[:format] == "html"
  end

end
