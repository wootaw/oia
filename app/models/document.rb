class Document < ApplicationRecord
  include AASM

  belongs_to :project

  has_many :resources, dependent: :destroy
  has_many :descriptions, as: :owner, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }, uniqueness: { scope: :project }
  validates :summary, presence: true, length: { minimum: 2, maximum: 50 }, uniqueness: { scope: :project }

  enum state: {
    mounted: 1,
    running: 99
  }

  aasm column: :state, enum: true do
    state :mounted, initial: true
    state :running
  end
end
