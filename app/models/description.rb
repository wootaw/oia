class Description < ApplicationRecord
  include AASM

  belongs_to :owner, polymorphic: true

  acts_as_list scope: [:owner]
  
  enum state: {
    mounted: 1,
    running: 99
  }

  aasm column: :state, enum: true do
    state :mounted, initial: true
    state :running
  end
end
