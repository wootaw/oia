class Document < ApplicationRecord
  include AASM
  include Versionable
  include Flagable

  belongs_to :project

  has_many :flags, as: :owner, dependent: :destroy
  has_many :resources, dependent: :destroy
  has_many :descriptions, as: :owner, dependent: :destroy

  delegate :lastest_change, to: :project, prefix: false

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }, uniqueness: { scope: :project_id }
  validates :position, presence: true
  # validates :summary, presence: true, length: { minimum: 2, maximum: 50 }, uniqueness: { scope: :project }

  accepts_nested_attributes_for :flags
  accepts_nested_attributes_for :descriptions
  accepts_nested_attributes_for :resources
  current_set :resources

  def self.attributes_by_json(data)
    attrs = data.slice(:name, :summary)
    [:description, :flag, :resource].each { |f| init_association(data, attrs, f) }
    attrs
  end

  def changes_by_expect(data)
    attrs = {}
    attrs[:name] = data[:name] unless self.name == data[:name]
    attrs[:summary] = data[:summary] unless self.summary == data[:summary]
    replace_descriptions(data, attrs)
    replace_flags(data, attrs)
    replace_association(data, attrs, :resource)

    attrs[:id] = self.id if attrs.size > 0
    attrs
  end

end
