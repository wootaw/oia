class Inout < ApplicationRecord
  enum clazz: %i(header param return error)

  belongs_to :resource

  has_many :descriptions, as: :owner, dependent: :destroy

  validates :name, :required, :clazz, presence: true
  validates :key, presence: true, uniqueness: { scope: :resource }
  validates :summary, length: { minimum: 2, maximum: 50 }

  acts_as_tree

  before_create :generate_key

  protected
  
  def generate_key
    self.key = Digest::MD5.hexdigest("#{self.clazz}|#{self.parent_id}|#{self.name}")
  end
end
