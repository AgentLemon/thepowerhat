object @post

attributes :id, :title

node :message do |p|
  text_with_tags p.message
end

node :text do |p|
  p.message
end

node :url do |p|
  post_path(p)
end

node :authenticity_token do |p|
  form_authenticity_token
end

child :images do
  attributes :id

  node :uploaded do |i|
    i.file.present?
  end

  node :thumbUrl do |i|
    file_image_path(i, :small)
  end

  node :url do |i|
    file_image_path(i)
  end
end

child :secured_messages => :securedMessages do
  attributes :id

  node :url do |m|
    secured_message_path(m, format: :json)
  end
end

