class Group < ApplicationRecord
  include AASM

  belongs_to :team

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }, uniqueness: { scope: :team }

  enum state: {
    mounted: 1,
    running: 99
  }

  aasm column: :state, enum: true do
    state :mounted, initial: true
    state :running
  end
end
