FactoryGirl.define do
  factory :resource do
    sequence(:method)      { |n| Resource::methods.keys.sample }
    sequence(:path)        { |n| "/resource_path#{n}" }
    sequence(:key)         { |n| Digest::MD5.hexdigest("#{self.method}|/resource_path#{n}") }
    sequence(:position)    { |n| n }
    sequence(:summary)     { |n| "resource_summary#{n}" }
    sequence(:slug)        { |n| "resource_slug#{n}" }
    association :document, factory: :document
  end
end
