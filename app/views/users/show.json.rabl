object @user

attributes :id,
           :username,
           :role,
           :avatar_url,
           :paid,
           :debt

child @user.debts => "debts" do
  attributes :username,
             :whom_id,
             :avatar_url,
             :amount
end

child @user.paids => "paids" do
  attributes :username,
             :who_id,
             :avatar_url,
             :amount
end
