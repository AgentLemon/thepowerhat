module Concerns

  module Paginated

    extend ActiveSupport::Concern

    included do

      helper_method :page

      def page
        params[:page].try(:to_i) || 1
      end

    end

  end

end
