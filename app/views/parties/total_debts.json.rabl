object :@debts => nil

node :total_debt do
  @debts.total_debt
end

child @debts.debts => "debts" do
  extends "debts/show.json.rabl"
end

child @debts.paids => "paids" do
  extends "debts/show.json.rabl"
end
