class Post < ActiveRecord::Base

  include Tag::Support
  include Concerns::Paginatable

  validates_presence_of :user_id, :message

  belongs_to :user
  has_many :secured_messages, -> { order(:id) }, class_name: "SecuredMessage", dependent: :destroy
  has_many :images, -> { order(:id) }, class_name: "::Image", dependent: :destroy

  accepts_nested_attributes_for :secured_messages, allow_destroy: true
  accepts_nested_attributes_for :images, allow_destroy: true

  auto_tags :message
  before_save :set_title

  scope :ordered, -> do
    order("posts.updated_at desc")
  end

  def has_attachments?
    secured_messages.count + images.count > 0
  end

  def checkboxes_attributes=(checkboxes)
    checkboxes.each { |c| set_checkbox(c[:id], c[:value]) }
  end

  protected

  def set_checkbox(id, value)
    char = value ? 'x' : ' '
    start, indices = -1, []
    indices << start while (start = (message.index /\[.\]/, start + 1))
    message[indices[id] + 1] = char if indices.size > id
  end

  def set_title
    if title.blank?
      self.title = message.truncate(27, separator: " ")
    end
  end

end
