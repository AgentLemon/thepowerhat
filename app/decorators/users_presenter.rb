class UsersPresenter < SimpleDelegator

  PAGE_SIZE = 10

  def initialize(scope, page)
    @scope = scope
    @page = page
    super(scope)
  end

  def users
    @users ||= begin
      users = @scope
      if @page.present?
        users = users.page(@page, per_page: PAGE_SIZE)
      end
      users.map{ |u| UserPresenter.new(u) }
    end
  end

  def remain_pages
    @remain_pages ||= @scope.pages(PAGE_SIZE) - @page
  end

end
