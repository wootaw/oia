class Team < ApplicationRecord
  include AASM

  has_many :members, dependent: :destroy
  has_many :groups, dependent: :destroy
  has_many :projects, as: :owner, dependent: :destroy

  has_many :users, through: :members, source: :user

  validates_format_of :name, with: /\A[a-zA-Z0-9_-]*\Z/
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }, uniqueness: true
  validates :name, exclusion: { in: A::RESERVED_WORDS, message: "%{value} is reserved." }
  validates :summary, presence: true

  enum state: {
    mounted: 1,
    running: 99
  }

  aasm column: :state, enum: true do
    state :mounted, initial: true
    state :running
  end
end
