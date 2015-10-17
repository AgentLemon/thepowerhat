module Concerns

  module Taggable

    extend ActiveSupport::Concern

    included do

      def tags_line
        tags_list.map{ |i| "##{i.name}" }.join(" ")
      end

      def tags_array
        tags_list.map(&:name)
      end

      def tags_list
        tag_links.map(&:tag)
      end

    end

  end

end
