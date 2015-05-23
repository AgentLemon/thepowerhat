object @post

attributes :id,
           :amount,
           :comment,
           :date,
           :date_formatted,
           :tags_line

node :tags do |post|
  post.tags_array
end

node :tags_line_formatted do |post|
  text_with_tags(post.tags_line)
end