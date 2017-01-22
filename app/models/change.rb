class Change < ApplicationRecord
  include AASM

  belongs_to :project

  validates :version, presence: true, uniqueness: { scope: :project }

  acts_as_list scope: [:project]
  
  enum state: {
    mounted: 1,
    running: 99
  }

  aasm column: :state, enum: true do
    state :mounted, initial: true
    state :running
  end
end
