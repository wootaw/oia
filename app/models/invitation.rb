class Invitation < ApplicationRecord
  has_one :collaborator, as: :member, dependent: :destroy
end
