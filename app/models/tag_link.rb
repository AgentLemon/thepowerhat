class TagLink < ActiveRecord::Base

  belongs_to :tag
  belongs_to :link, polymorphic: true

end
