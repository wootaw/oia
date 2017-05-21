class Collaborator < ApplicationRecord
  include AASM

  belongs_to :project
  belongs_to :user    # inviter
  belongs_to :member, polymorphic: true

  enum state: {
    mounted:    10,
    confirmed:  30,
    declined:   50,
    joined:     70,
    left:       90
  }

  aasm column: :state, enum: true do
    state :mounted, initial: true
    state :confirmed, :declined, :joined, :left

    event :confirm do
      transitions from: :mounted, to: :confirmed
    end

    event :join do
      transitions from: :mounted, to: :joined
    end

    event :decline do
      transitions from: :mounted, to: :declined
    end

    event :leave do
      transitions from: :joined, to: :left
    end

    event :back do
      transitions from: :left, to: :joined
      transitions from: :declined, to: :mounted
    end
  end
end
