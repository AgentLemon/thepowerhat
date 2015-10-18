class ApplicationController < ActionController::Base

  before_filter :require_login

  protected

  def not_authenticated
    respond_to do |format|
      format.html { redirect_to login_path }
      format.json { render status: :forbidden, json: { redirect: login_path, error: I18n.t("user.access_denied") } }
    end
  end

  def render_markup_if_html
    render_layout if params[:format].nil? || params[:format] == "html"
  end

  def render_layout
    render("layouts/application", layout: false)
  end

end
