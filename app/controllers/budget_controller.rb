class BudgetController < ApplicationController

  include Concerns::ControllerTags

  respond_to :html, :json

  before_filter :render_markup_if_html
  before_filter :load_budget, only: [:update, :show, :destroy]

  PAGE_SIZE = 10

  def index
    scope = current_user.budget.by_tags(*search_tags).exclude_tags(*excluded_tags)
    scope = scope.from_date(Date.strptime(params[:start_date])) if params[:start_date].present?
    scope = scope.to_date(Date.strptime(params[:end_date])) if params[:end_date].present?
    scope = scope.includes(:tag_links, :tags)
    @budget = BudgetListPresenter.new(scope.ordered)
  end

  def new
    @post = Budget.new(date: Date.today)
    decorate_post!
    render :show
  end

  def update
    @post.update_attributes(budget_params)
    decorate_post!
    render :show
  end

  def create
    @post = current_user.budget.create(budget_params)
    decorate_post!
    render :show
  end

  def destroy
    @post.destroy!
    head :ok
  end

  private

  def decorate_post!
    @post = BudgetPresenter.new(@post)
  end

  def load_budget
    @post = current_user.budget.find(params[:id])
  end

  def budget_params
    params.require(:budget).permit(
      :amount,
      :comment,
      :date,
      :tags_line
    )
  end

  def page
    params[:page].try(:to_i) || 1
  end

end
