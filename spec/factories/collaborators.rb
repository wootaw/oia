FactoryGirl.define do
  factory :collaborator do
    association :project, factory: :project_user

    factory :collaborator_user do
      association :member, factory: :user
    end

    factory :collaborator_invitation do
      association :member, factory: :invitation
    end
  end
end
