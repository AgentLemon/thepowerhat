require "spec_helper"

describe RecountDebtsJob do

  include GeneralHelper

  context "3 users" do

    let(:users) { (0..2).map{ create(:user) } }

    after :each do
      Debt.delete_all
    end

    it "recounts debts for 3 users example" do
      Debt.create!(who: users[0], whom: users[1], amount: 100)
      Debt.create!(who: users[1], whom: users[2], amount: 200)
      Debt.create!(who: users[2], whom: users[0], amount: 300)

      RecountDebtsJob.perform(users)

      expect(Debt.count).to eq(2)
      expect(Debt.find_debt(users[1], users[0]).amount).to eq(100)
      expect(Debt.find_debt(users[2], users[0]).amount).to eq(100)
    end

    it "takes reversed debts into account" do
      Debt.create!(who: users[0], whom: users[1], amount: 150)
      Debt.create!(who: users[1], whom: users[2], amount: 250)
      Debt.create!(who: users[2], whom: users[0], amount: 350)

      Debt.create!(who: users[1], whom: users[0], amount: 50)
      Debt.create!(who: users[2], whom: users[1], amount: 50)
      Debt.create!(who: users[0], whom: users[2], amount: 50)

      RecountDebtsJob.perform(users)

      expect(Debt.count).to eq(2)
      expect(Debt.find_debt(users[1], users[0]).amount).to eq(100)
      expect(Debt.find_debt(users[2], users[0]).amount).to eq(100)
    end

  end

  context "5 users" do

    let(:users) { (0..4).map{ create(:user) } }

    after :each do
      Debt.delete_all
    end

    it "recounts debts for 5 users example" do
      Debt.create!(who: users[1], whom: users[0], amount: 900)
      Debt.create!(who: users[0], whom: users[2], amount: 700)
      Debt.create!(who: users[3], whom: users[0], amount: 15)
      Debt.create!(who: users[0], whom: users[4], amount: 10)

      Debt.create!(who: users[2], whom: users[1], amount: 800)
      Debt.create!(who: users[1], whom: users[3], amount: 7)
      Debt.create!(who: users[4], whom: users[1], amount: 10)

      Debt.create!(who: users[2], whom: users[3], amount: 8)
      Debt.create!(who: users[4], whom: users[2], amount: 5)

      Debt.create!(who: users[3], whom: users[4], amount: 5)

      RecountDebtsJob.perform(users)

      expect(Debt.count).to eq(10)
      expect(Debt.find_debt(users[1], users[0]).amount).to eq(60.4)
      expect(Debt.find_debt(users[2], users[0]).amount).to eq(61.6)
      expect(Debt.find_debt(users[3], users[0]).amount).to eq(42)
      expect(Debt.find_debt(users[4], users[0]).amount).to eq(41)

      expect(Debt.find_debt(users[2], users[1]).amount).to eq(1.2)
      expect(Debt.find_debt(users[1], users[3]).amount).to eq(18.4)
      expect(Debt.find_debt(users[1], users[4]).amount).to eq(19.4)

      expect(Debt.find_debt(users[2], users[3]).amount).to eq(19.6)
      expect(Debt.find_debt(users[2], users[4]).amount).to eq(20.6)

      expect(Debt.find_debt(users[3], users[4]).amount).to eq(1)
    end

  end

end
