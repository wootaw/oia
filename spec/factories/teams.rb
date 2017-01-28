FactoryGirl.define do
  factory :team do
    sequence(:name)      { |n| "team_name#{n}" }
  end
end
