FactoryGirl.define do
  factory :description do
    sequence(:content)      { |n| "description_content#{n}" }
    sequence(:version)      { |n| n }
    sequence(:key)          { |n| Digest::MD5.hexdigest("description_content#{n}") }
    sequence(:position)     { |n| n }
  end
end
