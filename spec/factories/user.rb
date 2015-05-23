FactoryGirl.define do

  factory :user do
    sequence(:first_name){ |i| "User_#{i}" }
    sequence(:last_name){ |i| "User_#{i}" }
    sequence(:email){ |i| "user#{i}@example.com" }
    password "111111"
    password_confirmation "111111"
  end

end
