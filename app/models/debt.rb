class Debt < ActiveRecord::Base

  belongs_to :who, class_name: User
  belongs_to :whom, class_name: User

  def self.find_debt(who, whom)
    if who.is_a?(Numeric) && whom.is_a?(Numeric)
      find_by_who_id_and_whom_id(who, whom) || Debt.new(who_id: who, whom_id: whom, amount: 0)
    else
      find_by_who_id_and_whom_id(who.id, whom.id) || Debt.new(who: who, whom: whom, amount: 0)
    end
  end

  def reversed
    Debt.find_debt(whom, who)
  end

end
