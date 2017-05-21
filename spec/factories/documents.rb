FactoryGirl.define do
  factory :document do
    sequence(:name)      { |n| "document_name#{n}" }
    sequence(:summary)   { |n| "document_summary#{n}" }
    sequence(:position)  { |n| n }
    association :project, factory: :project
  end
end
