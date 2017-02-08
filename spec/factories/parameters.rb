FactoryGirl.define do
  factory :parameter do
    sequence(:location)    { |n| Inout::locations.keys.sample }
    sequence(:name)        { |n| "parameter_name#{n}" }
    required               true
    sequence(:position)    { |n| n }
    sequence(:summary)     { |n| "parameter_summary#{n}" }
    sequence(:key)         { |n| Digest::MD5.hexdigest("#{self.clazz}s||#{self.name}") }
    association :resource, factory: :resource
  end
end
