class Document < ApplicationRecord
  include AASM

  belongs_to :project

  has_many :resources, dependent: :destroy
  has_many :descriptions, as: :owner, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }, uniqueness: { scope: :project }
  validates :summary, presence: true, length: { minimum: 2, maximum: 50 }, uniqueness: { scope: :project }

  acts_as_list scope: [:project_id]
end
