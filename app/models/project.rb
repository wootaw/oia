class Project < ApplicationRecord
  include AASM
  include Versionable
  include DocumentUpdate

  belongs_to :owner, polymorphic: true

  has_one :lastest_change, -> { order 'position DESC' }, class_name: 'Change'

  has_many :documents, dependent: :destroy
  has_many :tapes, dependent: :destroy
  has_many :version_changes, dependent: :destroy, class_name: 'Change'

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }, uniqueness: { scope: :owner }
  validates :summary, presence: true
  validates :access_key, presence: true, uniqueness: true
  validates :secret_key, presence: true

  accepts_nested_attributes_for :documents

  # enum state: {
  #   mounted: 1,
  #   running: 99
  # }

  # aasm column: :state, enum: true do
  #   state :mounted, initial: true
  #   state :running
  # end

  def version_number
    "#{major_version}.#{minor_version}.#{patch_version}.#{changes_version}"
  end

  
end
