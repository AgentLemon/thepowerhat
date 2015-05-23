class PartyMemberPresenter < SimpleDelegator

  def initialize(obj)
    @obj = obj
    super(obj)
  end

  def username
    user.username
  end

  def avatar_url
    user.avatar.url
  end

  def user
    @user ||= UserPresenter.new(@obj.user)
  end

end
