FactoryGirl.define do
  factory :inout do
    sequence(:clazz)       { |n| Inout::clazzs.keys.sample }
    sequence(:name)        { |n| "inout_name#{n}" }
    sequence(:required)    { |n| [true, false].sample }
    sequence(:position)    { |n| n }
    sequence(:summary)     { |n| "inout_summary#{n}" }
    sequence(:key)         { |n| Digest::MD5.hexdigest("#{self.clazz}s||#{self.name}") }
    association :resource, factory: :resource
  end
end
