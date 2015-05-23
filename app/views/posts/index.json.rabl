node :remain_pages do
  @remain_pages
end

node :page do
  page
end

child @posts do
  extends "posts/show.json.rabl"
end

