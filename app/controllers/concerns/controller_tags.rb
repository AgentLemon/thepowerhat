module Concerns

  module ControllerTags

    extend ActiveSupport::Concern

    included do

      def search_tags
        params_tags.try(:reject){ |tag_name| tag_name =~ /^-/ }
      end

      def excluded_tags
        params_tags.try(:select){ |tag_name| tag_name =~ /^-/ }.try(:map){ |i| i.match(/^-(.*)/)[1] }
      end

      def params_tags
        @params_tags ||= params[:search].try(:split, ' ')
      end

    end

  end

end
