class Resource < ApplicationRecord
  include AASM

  belongs_to :document

  has_many :inouts, dependent: :destroy
  has_many :descriptions, as: :owner, dependent: :destroy

  delegate :project, to: :document, prefix: false

  validates :method, :path, presence: true
  validates :key, presence: true, uniqueness: { scope: :document_id }
  validates :summary, presence: true, length: { minimum: 2, maximum: 50 }, uniqueness: { scope: :document_id }

  # acts_as_list scope: [:document_id]

  # before_create :generate_key

  enum method: %i(GET HEAD POST PUT DELETE PATCH TRACE OPTIONS CONNECT)
  # enum state: {
  #   mounted: 1,
  #   running: 99
  # }

  # aasm column: :state, enum: true do
  #   state :mounted, initial: true
  #   state :running
  # end

  protected

  # def generate_key
  #   self.key = Digest::MD5.hexdigest("#{self.method}|#{self.path}")
  # end
end
