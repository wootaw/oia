FactoryGirl.define do
  factory :project do
    sequence(:name)      { |n| "project_name#{n}" }
    sequence(:key)       { |n| "project_key#{n}" }
    sequence(:token)     { |n| "project_token#{n}" }

    factory :project_user do
      association :owner, factory: :user
    end

    factory :project_team do
      association :owner, factory: :team
    end
  end
end
