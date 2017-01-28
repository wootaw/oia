class Document < ApplicationRecord
  include AASM
  include Versionable

  belongs_to :project

  has_many :resources, dependent: :destroy
  has_many :descriptions, as: :owner, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }, uniqueness: { scope: :project }
  validates :summary, presence: true, length: { minimum: 2, maximum: 50 }, uniqueness: { scope: :project }

  accepts_nested_attributes_for :descriptions
  accepts_nested_attributes_for :resources

end
