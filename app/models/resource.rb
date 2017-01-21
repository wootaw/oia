class Resource < ApplicationRecord
  enum method: %i(GET HEAD POST PUT DELETE PATCH TRACE OPTIONS CONNECT)

  belongs_to :document

  has_many :inouts, dependent: :destroy
  has_many :descriptions, as: :owner, dependent: :destroy

  delegate :project, to: :document, prefix: false

  validates :method, :path, presence: true
  validates :key, presence: true, uniqueness: { scope: :project }
  validates :summary, presence: true, length: { minimum: 2, maximum: 50 }, uniqueness: { scope: :document }

  before_create :generate_key

  protected
  
  def generate_key
    self.key = Digest::MD5.hexdigest("#{self.method}|#{self.path}")
  end
end
