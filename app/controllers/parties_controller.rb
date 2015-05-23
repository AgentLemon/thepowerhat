class PartiesController < ApplicationController

  include Concerns::ControllerTags
  include Concerns::Paginated

  respond_to :html, :json

  before_filter :render_markup_if_html
  before_filter :load_party, only: [:update, :show, :destroy]

  def index
    scope = current_user.parties.by_tags(*search_tags).exclude_tags(*excluded_tags)
    scope = scope.includes(:tags)
    @parties = PartiesPresenter.new(scope, current_user, page)
  end

  def new
    @party = Party.new(leader: current_user, date: Date.today)
    @party.party_members.build(user: current_user)
    decorate_party!
    render :show
  end

  def update
    @party.update_attributes(party_params)
    decorate_party!
    render :show
  end

  def create
    @party = Party.create(party_params)
    decorate_party!
    render :show
  end

  def destroy
    @party.destroy!
    head :ok
  end

  def total_debts
    @debts = TotalDebtsPresenter.new(current_user)
    render :total_debts
  end

  private

  def load_party
    @party = current_user.parties.find(params[:id])
  end

  def decorate_party!
    @party = PartyPresenter.new(@party)
  end

  def party_params
    params.require(:party).permit(
      :title,
      :date,
      :tags_line,
      :leader_id,
      party_members_attributes: [
        :id,
        :user_id,
        :debt,
        :paid,
        :_destroy
      ]
    )
  end

  def page
    params[:page].try(:to_i) || 1
  end

end
