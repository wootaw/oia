class Change < ApplicationRecord
  include AASM

  validates :version, presence: true
  
  enum state: {
    mounted: 1,
    running: 99
  }

  aasm column: :state, enum: true do
    state :mounted, initial: true
    state :running
  end
end
