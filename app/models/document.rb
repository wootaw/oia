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
  validates :summary, presence: true, length: { minimum: 2, maximum: 50 }, uniqueness: { scope: :project }

  accepts_nested_attributes_for :flags
  accepts_nested_attributes_for :descriptions
  accepts_nested_attributes_for :resources

  def self.attributes_by_json(data)
    attrs = data.slice(:name, :summary)
    init_descriptions(data, attrs)
    init_flags(data, attrs)

    res_lastest = (data[:resources] || []).map { |r| Resource.attributes_by_json(r) }
    res_lastest.each_with_index { |r, i| r[:position] = 1000 * i }
    attrs[:resources_attributes] = res_lastest unless res_lastest.length == 0
    attrs
  end

  def changes_by_expect(data)
    attrs = {}
    attrs[:name] = data[:name] unless self.name == data[:name]
    attrs[:summary] = data[:summary] unless self.summary == data[:summary]
    replace_descriptions(data, attrs)
    replace_flags(data, attrs)

    lresources  = lastest_change.nil? ? [] : lastest_change.parts(self, :resources)
    res_lastest = lresources.map { |o| { key: o.key, position: o.position, id: o.id } }
    res_expects = (data[:resources] || []).map { |r| Resource.attributes_by_json(r) }
    res_indexs  = lresources.map { |r| { resource: r, idx: res_expects.index { |o| o[:key] == r.key } } }
    res_removes = merge_lastest_with_expects(res_lastest, res_expects)
    res_arrange = rearrange(res_lastest, :resources)
    res_changes = []

    res_indexs.each do |rx|
      next if rx[:idx].nil?
      changed_res_attrs = rx[:resource].changes_by_expect(data[:resources][rx[:idx]])
      next if changed_res_attrs.size == 0

      idx = res_arrange.index { |o| o[:id] == changed_res_attrs[:id] }
      if idx.nil?
        res_changes << changed_res_attrs
      else
        res_arrange[idx].merge!(changed_res_attrs)
      end
    end

    if res_removes.length + res_arrange.length + res_changes.length > 0
      attrs[:resources_attributes] = res_removes + res_arrange + res_changes
    end

    attrs[:id] = self.id if attrs.size > 0
    attrs
  end

end
