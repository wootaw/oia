class Flag < ApplicationRecord
  include Versionable

  belongs_to :owner, polymorphic: true

  has_many :descriptions, as: :owner, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }

  accepts_nested_attributes_for :descriptions
  
  def self.attributes_by_json(data)
    data.symbolize_keys!
    attrs = data.slice(:name, :summary)
    init_descriptions(data, attrs)
    attrs[:position] = 1 if attrs.size > 0
    attrs.compact
  end

  def changes_by_expect(data)
    data.symbolize_keys!
    attrs = {}

    if self.name == data[:name]
      attrs[:summary] = data[:summary] unless self.summary == data[:summary]
      replace_descriptions(data, attrs)
      attrs[:id] = self.id if attrs.size > 0
      return attrs, nil
    else
      return { id: self.id }, self.class.attributes_by_json(data)
    end
  end
end
