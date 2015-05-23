class TemplatesController < ApplicationController

  skip_before_filter :require_login

  layout "title_top"

  def posts
  end

  def post
  end

end
