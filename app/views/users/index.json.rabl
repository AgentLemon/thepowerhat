object :@users

node :remain_pages do
  @users.remain_pages
end

node :page do
  page
end

child @users.users => "users" do
  attributes :id,
             :username,
             :role,
             :avatar_url,
             :paid,
             :debt
end
