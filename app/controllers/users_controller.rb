class UsersController < ApplicationController

  include Concerns::Paginated

  respond_to :html, :json

  before_filter :render_markup_if_html
  before_filter :load_user, only: [:update]

  def profile
    id = params[:id]
    @user = current_user.admin? && id.present? ? User.find(params[:id]) : current_user
    decorate_user!
    render :profile
  end

  def index
    scope = User.includes(:debts, :paids).ordered
    scope = scope.active unless current_user.admin?
    if params[:search].present?
      search = "%#{params[:search].gsub(" ", "%")}%"
      scope = scope.where("first_name || last_name ilike ? or last_name || first_name ilike ?", search, search)
    end
    @users = UsersPresenter.new(scope, page)
  end

  def debts_matrix
    scope = User.active.includes(:debts, :paids)
    @users = UsersPresenter.new(scope, nil)
  end

  def recount_debts
    RecountDebtsJob.perform(User.active)
    redirect_to debts_matrix_users_path(format: :json)
  end

  def update
    @user.update_attributes(user_params)
    decorate_user!
    render :profile
  end

  def show
    @user = UserPresenter.new(User.includes(:debts).includes(:paids).find(params[:id]))
    render :show
  end

  def autocomplete
    @users = User.active.like(params[:like]).limit(10).map{ |u| UserPresenter.new(u) }
  end

  private

  def load_user
    if current_user.admin? || current_user.id == params[:id].to_i
      @user = User.find(params[:id])
    else
      render status: 403, json: { error: "You don't have permissions to do this" }
    end
  end

  def decorate_user!
    @user = UserPresenter.new(@user)
  end

  def user_params
    attrs = [
      :first_name,
      :last_name,
      :avatar,
      :password,
      :password_confirmation
    ]
    attrs.push(:email, :role) if current_user.admin?
    params.require(:user).permit(*attrs)
  end

end
