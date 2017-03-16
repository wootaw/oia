class Response < ApplicationRecord
  include Versionable

  enum location: %i(header body)

  belongs_to :resource

  has_many :descriptions, as: :owner, dependent: :destroy

  delegate :lastest_change, to: :resource, prefix: false

  validates :name, :location, :position, presence: true
  validates :key, presence: true, uniqueness: { scope: :resource }
  validates :position, presence: true
  # validates :summary, length: { minimum: 1, maximum: 50 }

  accepts_nested_attributes_for :descriptions

  def self.attributes_by_json(data)
    data.symbolize_keys!
    ancestor = (data[:parent] || []).join('.')
    ancestor = nil if ancestor.blank?
    attrs = data.slice(:name, :location, :group, :summary, :array, :options).merge({
      key: Digest::MD5.hexdigest("#{data[:location]}|#{ancestor}|#{data[:name]}"),
      ancestor: ancestor,
      data_type: data[:type]
    })

    init_association(data, attrs, :description)
    attrs
  end

  def changes_by_expect(data)
    data.symbolize_keys!
    attrs = {}
    old_attrs = self.attributes.symbolize_keys.slice(:data_type, :summary, :group, :array, :options)
    new_attrs = data.slice(:summary, :group, :array, :options).merge({ data_type: data[:type] })
    diffs = HashDiff.diff(old_attrs.compact, new_attrs.compact)

    if diffs.length == 0
      replace_descriptions(data, attrs)
      attrs[:id] = self.id if attrs.size > 0
      return attrs, nil
    else
      attrs = self.class.attributes_by_json(data)
      attrs[:position] = self.position
      return { id: self.id }, attrs
    end
  end

end
