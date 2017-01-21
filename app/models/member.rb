class Member < ApplicationRecord
  belongs_to :team
  belongs_to :user

  has_many :roles, dependent: :destroy

  has_many :groups, through: :roles, source: :group
end
