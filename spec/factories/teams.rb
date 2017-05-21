FactoryGirl.define do
  factory :team do
    sequence(:name)      { |n| "team_name#{n}" }
    sequence(:summary)   { |n| "team_summary#{n}" }
  end
end
