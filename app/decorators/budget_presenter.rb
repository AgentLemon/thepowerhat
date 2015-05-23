class BudgetPresenter < SimpleDelegator

  include Concerns::Taggable

  def initialize(obj)
    @obj = obj
    super(obj)
  end

  def date_formatted
    @obj.date.strftime("%d %b<br/>%Y")
  end

end
