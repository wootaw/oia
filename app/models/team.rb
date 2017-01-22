class Team < ApplicationRecord
  include AASM

  has_many :members, dependent: :destroy
  has_many :groups, dependent: :destroy
  has_many :projects, as: :owner, dependent: :destroy

  has_many :users, through: :members, source: :user

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }, uniqueness: true

  enum state: {
    mounted: 1,
    running: 99
  }

  aasm column: :state, enum: true do
    state :mounted, initial: true
    state :running
  end
end
