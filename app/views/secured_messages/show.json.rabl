object @message

attributes :id, :message

node :html do |m|
  simple_format(m.message)
end

node :error do |m|
  "Key doesn't match" if params[:key].present? && m.message.blank?
end