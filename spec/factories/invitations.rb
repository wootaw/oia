FactoryGirl.define do
  factory :invitation do
    sequence(:email)      { |n| "email#{n}@invitation#{n}.com" }
    sequence(:key)        { |n| "invitation_key#{n}" }
  end
end
