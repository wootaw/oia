class Inout < ApplicationRecord
  include AASM
  include Versionable

  enum clazz: %i(header parameter response)

  belongs_to :resource

  has_many :descriptions, as: :owner, dependent: :destroy

  delegate :lastest_change, to: :resource, prefix: false

  validates :name, :clazz, :position, presence: true
  validates :key, presence: true, uniqueness: { scope: :resource }
  validates :summary, length: { minimum: 1, maximum: 50 }

  # acts_as_tree

  accepts_nested_attributes_for :descriptions
  
  # acts_as_list scope: [:resource_id, :clazz]

  # before_create :generate_key
  
  # enum state: {
  #   mounted: 1,
  #   running: 99
  # }

  # aasm column: :state, enum: true do
  #   state :mounted, initial: true
  #   state :running
  # end

  def self.attributes_by_json(data, part)
    data.symbolize_keys!
    ancestor = (data[:parent] || []).join('.')
    ancestor = nil if ancestor.blank?
    attrs = data.slice(:name, :group, :summary, :required, :array, :default, :options).merge({
      key: Digest::MD5.hexdigest("#{part}|#{ancestor}|#{data[:name]}"),
      ancestor: ancestor,
      data_type: data[:type],
      clazz: part
    })

    init_descriptions(data, attrs)
    # ap attrs
    attrs
  end

  def changes_by_expect(data)
    data.symbolize_keys!
    attrs = {}
    old_attrs = self.attributes.symbolize_keys.slice(:group, :data_type, :summary, :required, :array, :default, :options)
    new_attrs = data.slice(:group, :summary, :required, :array, :default, :options).merge({ data_type: data[:type] })
    diffs = HashDiff.diff(old_attrs, new_attrs)

    if diffs.length == 0
      replace_descriptions(data, attrs)
      attrs[:id] = self.id if attrs.size > 0
      return attrs, nil
    else
      attrs = self.class.attributes_by_json(data, self.clazz)
      attrs[:position] = self.position
      return { id: self.id }, attrs
    end
  end

  protected

  # def generate_key
  #   self.key = Digest::MD5.hexdigest("#{self.clazz}|#{self.parent_id}|#{self.name}")
  # end
end
