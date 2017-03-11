FactoryGirl.define do
  factory :project do
    sequence(:name)       { |n| "project_name#{n}" }
    sequence(:access_key) { |n| "project_access_key#{n}" }
    sequence(:secret_key) { |n| "project_secret_key#{n}" }
    sequence(:clazz)      { |n| Project.clazzs.keys.sample }

    factory :project_user do
      association :owner, factory: :user
    end

    factory :project_team do
      association :owner, factory: :team
    end
  end
end
