object :@parties => nil

node :total_debt do
  @parties.total_debt
end

node :remain_pages do
  @parties.remain_pages
end

node :page do
  page
end

child @parties.parties => "parties" do
  extends "parties/show.json.rabl"
end

child @parties.debts => "debts" do
  extends "debts/show.json.rabl"
end

child @parties.paids => "paids" do
  extends "debts/show.json.rabl"
end
