class TagsController < ApplicationController

  respond_to :json

  before_filter :load_tags, only: [:autocomplete]

  def autocomplete
    @tags = @tags.limit(5)
    render json: @tags.map(&:name)
  end

  private

  def load_tags
    @tags = current_user.tags.like(params[:like])
  end

end
