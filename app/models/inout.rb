class Inout < ApplicationRecord
  include AASM

  enum clazz: %i(header param return error)

  belongs_to :resource

  has_many :descriptions, as: :owner, dependent: :destroy

  validates :name, :required, :clazz, presence: true
  validates :key, presence: true, uniqueness: { scope: :resource }
  validates :summary, length: { minimum: 2, maximum: 50 }

  acts_as_tree
  acts_as_list scope: [:resource, :clazz]

  before_create :generate_key
  
  enum state: {
    mounted: 1,
    running: 99
  }

  aasm column: :state, enum: true do
    state :mounted, initial: true
    state :running
  end

  protected

  def generate_key
    self.key = Digest::MD5.hexdigest("#{self.clazz}|#{self.parent_id}|#{self.name}")
  end
end
