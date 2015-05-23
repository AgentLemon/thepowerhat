class BudgetListPresenter < SimpleDelegator

  def initialize(obj)
    @obj = obj
    super(obj)
  end

  def remain_pages
    per_page.present? ? pages - current_page > 0 : false
  end

  def posts
    @posts ||= map{ |i| BudgetPresenter.new(i) }
  end

end
