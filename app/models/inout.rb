class Inout < ApplicationRecord
  include AASM
  include Versionable

  enum clazz: %i(header parameter response)

  belongs_to :resource

  has_many :descriptions, as: :owner, dependent: :destroy

  validates :name, :required, :clazz, :position, presence: true
  validates :key, presence: true, uniqueness: { scope: :resource }
  validates :summary, length: { minimum: 2, maximum: 50 }

  acts_as_tree

  accepts_nested_attributes_for :children
  
  # acts_as_list scope: [:resource_id, :clazz]

  # before_create :generate_key
  
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
  #   self.key = Digest::MD5.hexdigest("#{self.clazz}|#{self.parent_id}|#{self.name}")
  # end
end
