class Change < ApplicationRecord
  include AASM

  belongs_to :project

  validates :version, presence: true, uniqueness: { scope: :project }
  validates :position, presence: true

  acts_as_list scope: [:project_id]
  
  # enum state: {
  #   mounted: 1,
  #   running: 99
  # }

  # aasm column: :state, enum: true do
  #   state :mounted, initial: true
  #   state :running
  # end

  def parts(object, set)
    object.list_by_version(set, position)
  end
end
