class DebtPresenter < SimpleDelegator

  def initialize(obj)
    @obj = obj
    super(obj)
  end

  def user
    @user ||= UserPresenter.new(@obj.whom)
  end

  def username
    user.username
  end

  def avatar_url
    user.avatar_url
  end

end
