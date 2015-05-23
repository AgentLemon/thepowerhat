class User < ActiveRecord::Base

  include Concerns::Paginatable

  attr_accessor :password_confirmation

  authenticates_with_sorcery!

  symbolize :role, in: [:blocked, :user, :admin], default: :user, methods: true

  has_many :posts, -> { order 'posts.created_at desc' }
  has_many :budget, -> { order 'budget.date desc' }
  has_many :tags, -> { order 'tags.name' }
  has_many :party_members
  has_many :parties, -> { order 'parties.date desc, parties.id desc' }, through: :party_members
  has_many :debts, class_name: Debt, foreign_key: :who_id
  has_many :paids, class_name: Debt, foreign_key: :whom_id

  validates_presence_of :last_name, :first_name, :email
  validate :passwords_match

  mount_uploader :avatar, AvatarUploader

  scope :active, -> { where("role != 'blocked'") }

  scope :ordered, -> { order(:first_name, :last_name) }

  scope :like, -> str {
    str = "%#{str}%"
    where("users.first_name || ' ' || users.last_name ilike ? or users.last_name || ' ' || users.first_name ilike ?", str, str)
  }

  def active?
    role.to_sym != :blocked
  end

  def self.create_from_github!(params)
    info = params["info"]
    name = (info.try(:[], "name").presence || info.try(:[], "nickname").presence || "Github User").split(" ")
    user = create!(
      role: "blocked",
      github_uid: params["uid"],
      email: info.try(:[], "email") || "github#{params["uid"]}",
      first_name: name.first,
      last_name: name.last
    )
    user.update_attributes(remote_avatar_url: info.try(:[], "image"))
    user
  end

  private

  def passwords_match
    if password.present? && password != password_confirmation
      errors.add(:password, "doesn't match confirmation")
    end
  end

end
