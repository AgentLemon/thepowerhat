object :@users

child @users.users => "users" do

  attributes :id,
             :username,
             :role,
             :avatar_url,
             :paid,
             :debt

  child :debts => "debts" do
    attributes :whom_id,
               :amount
  end

end
