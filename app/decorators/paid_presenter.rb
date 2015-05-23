class PaidPresenter < DebtPresenter

  def user
    @user ||= UserPresenter.new(@obj.who)
  end

end
