class HomeController < ApplicationController

  before_filter :render_markup_if_html, only: :profile
  skip_before_filter :require_login, only: [:login_user, :token, :omniauth_login]

  helper_method :page, :last_page?

  PAGE_SIZE = 10

  def index
    render nothing: true, layout: true
  end

  def login_user
    if request.post?
      user = login params[:email], params[:password], params[:remember_me]
      if user.present? && user.active?
        render json: { redirect: session[:return_to_url].presence || root_path, success: I18n.t("user.logged_in") }
      elsif user.present?
        logout
        render json: { error: I18n.t("user.blocked_login") }
      else
        render json: { error: I18n.t("user.wrong_password") }
      end
    else
      render nothing: true, layout: true
    end
  end

  def omniauth_login
    auth_hash = request.env["omniauth.auth"]
    user = User.find_by_github_uid(auth_hash["uid"]) || User.create_from_github!(auth_hash)
    if user.present?
      if user.active?
        auto_login(user, true)
      else
        flash[:error] = I18n.t("user.blocked_login")
      end
    end
    redirect_to(root_path)
  end

  def token
    render text: form_authenticity_token
  end

  def logout_user
    logout
    respond_to do |format|
      format.html { redirect_to login_path }
      format.json { render json: { redirect: login_path } }
    end
  end

  protected

  def last_page?
    count = posts.count
    (count / PAGE_SIZE) + (count % PAGE_SIZE != 0 ? 1 : 0) <= page
  end

  def posts
    current_user.posts.by_tags(*tags)
  end

  def page
    params[:page].try(:to_i) || 1
  end

  def tags
    @tags ||= (params[:search].try(:split, " ") || []).map{ |t| "%#{t}%" }
  end

end
