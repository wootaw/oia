FactoryGirl.define do
  factory :project do
    sequence(:name)       { |n| "project_name#{n}" }
    sequence(:access_key) { |n| "project_access_key#{n}" }
    sequence(:secret_key) { |n| "project_secret_key#{n}" }

    factory :project_user do
      association :owner, factory: :user
    end

    factory :project_team do
      association :owner, factory: :team
    end
  end
end
