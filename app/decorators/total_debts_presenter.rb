class TotalDebtsPresenter

  include Concerns::PresentsDebts

  def initialize(user)
    @user = user
  end

end