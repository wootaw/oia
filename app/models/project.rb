class Project < ApplicationRecord
  include AASM

  belongs_to :owner, polymorphic: true

  has_many :documents, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }, uniqueness: { scope: :owner }
  validates :key, presence: true, uniqueness: true
  validates :token, presence: true

  enum state: {
    mounted: 1,
    running: 99
  }

  aasm column: :state, enum: true do
    state :mounted, initial: true
    state :running
  end
end
