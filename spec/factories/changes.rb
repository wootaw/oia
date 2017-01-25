FactoryGirl.define do
  factory :change do
    sequence(:version)      { |n| "change_version#{n}" }
  end
end
