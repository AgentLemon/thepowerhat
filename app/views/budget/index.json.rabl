object :@budget => nil

child @budget.posts => "posts" do
  extends "budget/show.json.rabl"
end
