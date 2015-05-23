require "spec_helper"

describe Party do

  include GeneralHelper

  let(:users) { (0..1).map{ create(:user) } }

  context "2 users" do

    before :each do
      create_party!(
        users[0], 200, 0,
        users[1], 100, 30
      )
    end

    after :each do
      Debt.delete_all
    end

    it "creates debts for member" do
      expect(Debt.where(who_id: users[0].id, whom_id: users[1].id).first.amount).to eq(200)
    end

    it "adds debts" do
      create_party!(
        users[0], 100, 0,
        users[1], 150, 250
      )

      expect(Debt.where(who_id: users[0].id, whom_id: users[1].id).first.amount).to eq(300)
    end

    it "adds debt back" do
      create_party!(
        users[0], 100, 250,
        users[1], 150, 0
      )

      expect(Debt.where(who_id: users[0].id, whom_id: users[1].id).first.amount).to eq(200)
      expect(Debt.where(who_id: users[1].id, whom_id: users[0].id).first.amount).to eq(150)
    end

  end

end
