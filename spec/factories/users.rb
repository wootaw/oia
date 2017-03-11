FactoryGirl.define do
  factory :user do
    sequence(:username)   { |n| "username#{n}" }
    sequence(:email)      { |n| "email#{n}@user#{n}.com" }
    password 'password'
  end
end
