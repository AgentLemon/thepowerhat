class Budget < ActiveRecord::Base

  attr_accessor :tags_line

  include Tag::Support
  include Concerns::Paginatable

  belongs_to :user

  auto_tags :tags_line
  set_make_tags

  scope :ordered, -> { order("budget.date desc, budget.created_at desc") }
  scope :from_date, -> date { date.present? ? where("date >= ?", date) : self }
  scope :to_date, -> date { date.present? ? where("date <= ?", date) : self }

end
