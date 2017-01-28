FactoryGirl.define do
  factory :user do
    sequence(:email)      { |n| "email#{n}@user#{n}.com" }
    password 'password'
  end
end
