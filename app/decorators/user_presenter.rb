class UserPresenter < SimpleDelegator

  include Concerns::PresentsDebts

  def initialize(obj)
    @user = obj
    super(obj)
  end

  def username
    "#{first_name} #{last_name}"
  end

  def avatar_url
    @user.avatar.url
  end

  def invalid_fields
    @user.invalid? ? @user.errors.keys : nil
  end

  def errors_list
    if @user.invalid?
      result = {}
      @user.errors.each{ |k, v| result[k] = @user.errors.full_message(k, v) }
      result
    else
      nil
    end
  end

  def error
    if @user.invalid?
      "Record can't be saved!"
    else
      nil
    end
  end

  def debt
    @user.debts.to_a.sum(&:amount)
  end

  def paid
    @user.paids.to_a.sum(&:amount)
  end

end
