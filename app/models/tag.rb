class Tag < ActiveRecord::Base

  validates_presence_of :user_id, :name

  belongs_to :user

  scope :like, -> str {
    if str.present?
      where('tags.name ilike ?', "%#{str}%")
    end
  }

  scope :from_array, -> tags {
    where('tags.name ilike any(array[?])', tags)
  }

end
