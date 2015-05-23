module Concerns

  module Paginatable

    extend ActiveSupport::Concern

    included do

      scope :page, -> (page, params = {}) do
        params = { per_page: 10 }.merge(params)

        @current_page = page || 1
        @per_page = params[:per_page]

        offset((@current_page - 1) * @per_page).limit(@per_page)
      end

      def self.pages(page_size = @per_page)
        count = self.limit(nil).offset(nil).count
        (count / page_size.to_f).ceil
      end

      def self.current_page
        @current_page
      end

      def self.per_page
        @per_page
      end

    end

  end

end