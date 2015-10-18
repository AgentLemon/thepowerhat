class TemplatesController < ApplicationController
  skip_before_filter :require_login
  layout false
end
