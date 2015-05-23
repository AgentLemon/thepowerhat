module Tag::Support

  extend ActiveSupport::Concern

  AUTOTAGS_REGEXP = /^[^#\n]*\z/
  TAGS_REGEXP = /((?<=\s)|^)#([\wа-яА-Я]+)/

  included do |base|

    has_many :tag_links, -> { order(:id) }, as: :link
    has_many :tags, class_name: "Tag", through: :tag_links

    scope :by_tags, -> (*tags) do
      if tags.try(:compact).present?
        where("#{table_name}.id in (?)", joins(:tags).where("tags.name ilike any(array[?])", tags.map{ |i| "%#{i}%" }).select(:id))
      end
    end

    scope :exclude_tags, -> (*tags) do
      if tags.try(:compact).present?
        where("#{table_name}.id not in (?)", joins(:tags).where("tags.name ilike any(array[?])", tags.map{ |i| "%#{i}%" }).select(:id))
      end
    end

    before_save :set_tags

    private

    def self.auto_tags(field)
      @auto_tags_field = field
    end

    def self.set_make_tags(value = true)
      @make_tags = value
    end

    def self.set_tags_scope(scope)
      eval %Q{
        def tags_scope
          #{scope}
        end
      }
    end

    def self.make_tags
      @make_tags
    end

    def self.auto_tags_field
      @auto_tags_field
    end

    def auto_tags_field_value
      @auto_tags_field_value ||= if self.class.auto_tags_field.present?
        send(self.class.auto_tags_field)
      else
        nil
      end
    end

    def set_tags
      if auto_tags_field_value.present?
        tags_line = auto_tags_field_value

        if self.class.make_tags
          tags_line.gsub!(/(^| )([^# ])/){ |a| "#{a.first if a.size == 2}##{a.last}" }
        end

        tags = tags_line.scan(TAGS_REGEXP).map{ |i| i[1] }

        autotags = (tags_line.scan(AUTOTAGS_REGEXP).first || "").strip.split(' ')
        if autotags.present?
          tags_line.sub!(AUTOTAGS_REGEXP, autotags.map{ |i| "##{i}" }.join(' '))
          tags += autotags
        end

        scoped_tags = respond_to?(:tags_scope) ? tags_scope : user.tags
        db_tags = scoped_tags.where("tags.name ilike any(array[?])", tags).load
        if db_tags.size != tags.size
          (tags - db_tags.map(&:name)).uniq.each{ |name| db_tags << scoped_tags.create!(name: name) }
        end

        self.tag_links = tags.map{ |t| TagLink.new(link: self, tag: db_tags.find{ |db_t| db_t.name.match(Regexp.new("^#{t}$", "g")) }) }
      end
    end

  end

end
