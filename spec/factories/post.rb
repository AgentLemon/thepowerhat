FactoryGirl.define do

  factory :post do
    association :user, factory: :user
    message "TEST"
  end

end