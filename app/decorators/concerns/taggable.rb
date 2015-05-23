module Concerns

  module Taggable

    extend ActiveSupport::Concern

    included do

      def tags_line
        tags.map{ |i| "##{i.name}" }.join(" ")
      end

      def tags_array
        tags.map(&:name)
      end

    end

  end

end
