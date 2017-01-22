module Versionable
  extend ActiveSupport::Concern

  included do
    enum state: {
      latest: 1,
      dated: 50,
      discarded: 99
    }

    aasm column: :state, enum: true do
      state :latest, initial: true
      state :dated, :discarded

      event :replace do
        transitions from: :latest, to: :dated
      end

      event :discard do
        transitions from: :latest, to: :discarded
      end

    end

  end
end