class PartiesPresenter < SimpleDelegator

  include Concerns::Taggable
  include Concerns::PresentsDebts

  PAGE_SIZE = 10

  def initialize(scope, user, page)
    @scope = scope
    @user = user
    @page = page
    super(scope)
  end

  def parties
    @parties ||= includes(:users).page(@page, per_page: PAGE_SIZE).map{ |i| PartyPresenter.new(i) }
  end

  def remain_pages
    @remain_pages ||= @scope.pages(PAGE_SIZE) - @page
  end

end
