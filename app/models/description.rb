class Description < ApplicationRecord
  include AASM

  belongs_to :owner, polymorphic: true

  validates :content, :version, :key, :position, presence: true

  # acts_as_list scope: [:owner_type, :owner_id]
  
  # before_save :generate_key

  enum state: {
    latest: 1,
    dated: 50,
    discarded: 99
  }

  # aasm column: :state, enum: true do
  #   state :mounted, initial: true
  #   state :running
  # end

  protected

  # def generate_key
  #   self.key = Digest::MD5.hexdigest(self.content)
  # end

end
