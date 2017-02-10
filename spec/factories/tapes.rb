FactoryGirl.define do
  factory :tape do
    association :project, factory: :project
  end
end
