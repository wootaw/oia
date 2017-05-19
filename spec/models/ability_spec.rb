require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  subject { ability }

  context 'Normal users' do
    let(:user) { create :user }
    
    context 'at self project' do
      let(:public_project) { create :project, owner: user, clazz: :jpublic }
      let(:private_project) { create :project, owner: user, clazz: :jprivate }

      let(:ability) { Ability.new(user, user) }

      it { is_expected.to be_able_to(:read, public_project) }
      it { is_expected.to be_able_to(:read, private_project) }
      it { is_expected.to be_able_to(:create, public_project) }
      it { is_expected.to be_able_to(:create, private_project) }
      it { is_expected.to be_able_to(:update, public_project) }
      it { is_expected.to be_able_to(:update, private_project) }
      it { is_expected.to be_able_to(:destroy, public_project) }
      it { is_expected.to be_able_to(:destroy, private_project) }
    end

    context 'at other project' do
      let(:other) { create :user }
      let(:other_public_project) { create :project, owner: other, clazz: :jpublic }
      let(:other_private_project) { create :project, owner: other, clazz: :jprivate }

      let(:ability) { Ability.new(user, other) }

      it { is_expected.to be_able_to(:read, other_public_project) }
      it { is_expected.not_to be_able_to(:read, other_private_project) }
      it { is_expected.not_to be_able_to(:create, other_public_project) }
      it { is_expected.not_to be_able_to(:create, other_private_project) }
      it { is_expected.not_to be_able_to(:update, other_public_project) }
      it { is_expected.not_to be_able_to(:update, other_private_project) }
      it { is_expected.not_to be_able_to(:destroy, other_public_project) }
      it { is_expected.not_to be_able_to(:destroy, other_private_project) }

      context 'is a collaborator at other private project' do
        before(:example) do
          create :collaborator, project: other_private_project, member: user, state: :joined
        end

        it { is_expected.to be_able_to(:read, other_private_project) }
        it { is_expected.not_to be_able_to(:create, other_private_project) }
        it { is_expected.not_to be_able_to(:update, other_private_project) }
        it { is_expected.not_to be_able_to(:destroy, other_private_project) }
      end
    end
  end

end