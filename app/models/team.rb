class Team < ApplicationRecord
  has_many :members, dependent: :destroy
  has_many :groups, dependent: :destroy
  has_many :projects, as: :owner, dependent: :destroy

  has_many :users, through: :members, source: :user

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }, uniqueness: true
end
