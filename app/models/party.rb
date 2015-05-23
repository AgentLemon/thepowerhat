class Party < ActiveRecord::Base

  include Concerns::Paginatable
  include Tag::Support

  attr_accessor :tags_line

  belongs_to :leader, class_name: User
  has_many :party_members, dependent: :destroy
  has_many :users, through: :party_members

  accepts_nested_attributes_for :party_members, allow_destroy: true

  auto_tags :tags_line
  set_make_tags
  set_tags_scope "leader.tags"

  before_update :remove_debts
  before_destroy :remove_debts
  after_save :add_debts

  private

  def remove_debts
    process_debt(:paid_was, :debt_was, -1)
  end

  def add_debts
    process_debt(:paid, :debt)
  end

  def process_debt(paid_method, debt_method, multiplier = 1)
    bank_members = party_members.select{ |i| i.send(paid_method) && i.send(paid_method) > 0 }
    total_paid = bank_members.sum(&paid_method)
    party_members.each do |member|
      bank_members.each do |bank|
        if member != bank && member.send(debt_method).present?
          debt = Debt.find_debt(member.user, bank.user)
          debt.update_attributes!(amount: debt.amount + multiplier * member.send(debt_method) * bank.send(paid_method) / total_paid)
        end
      end
    end
  end

end
