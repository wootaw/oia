class Resource < ApplicationRecord
  include AASM
  include Versionable
  include Flagable

  belongs_to :document

  has_many :flags, as: :owner, dependent: :destroy
  has_many :inouts, dependent: :destroy
  has_many :descriptions, as: :owner, dependent: :destroy

  has_many :headers,   -> { where clazz: :header },   class_name: "Inout"
  has_many :params,    -> { where clazz: :param },    class_name: "Inout"
  has_many :responses, -> { where clazz: :response }, class_name: "Inout"

  delegate :project, to: :document, prefix: false
  delegate :lastest_change, to: :project, prefix: false

  validates :method, :path, presence: true
  validates :key, presence: true, uniqueness: { scope: :document_id }
  validates :summary, presence: true, length: { minimum: 2, maximum: 50 }, uniqueness: { scope: :document_id }

  # acts_as_list scope: [:document_id]

  # before_create :generate_key

  enum method: %i(GET HEAD POST PUT DELETE PATCH TRACE OPTIONS CONNECT)

  accepts_nested_attributes_for :flags
  accepts_nested_attributes_for :inouts
  accepts_nested_attributes_for :descriptions

  # enum state: {
  #   mounted: 1,
  #   running: 99
  # }

  # aasm column: :state, enum: true do
  #   state :mounted, initial: true
  #   state :running
  # end

  def self.attributes_by_json(data)
    data.symbolize_keys!
    attrs = data.slice(:path, :summary).merge({ 
      key: Digest::MD5.hexdigest("#{data[:method].upcase}|#{data[:path]}"),
      method: data[:method].upcase,
    })
    init_descriptions(data, attrs)
    init_flags(data, attrs)

    inout_lastest = []
    Inout::clazzs.each do |cls|
      cls_lastest = (data["#{cls}s".to_sym] || []).map { |h| Inout.attributes_by_json(h, cls.to_sym) }
      cls_lastest.each_with_index { |r, i| r[:position] = 1000 * i }
      inout_lastest += cls_lastest
    end
    attrs[:inouts_attributes] = inout_lastest unless inout_lastest.length == 0
    attrs
  end

  def changes_by_expect(data)
    data.symbolize_keys!
    attrs = {}
    attrs[:summary] = data[:summary] unless self.summary == data[:summary]
    replace_descriptions(data, attrs)
    replace_flags(data, attrs)

    inout_jsons = []
    Inout::clazzs.each do |cls, v|
      part = cls.tableize.to_sym
      linouts = lastest_change.nil? ? [] : lastest_change.parts(self, part)
      lastest = linouts.map { |o| { key: o.key, position: o.position, id: o.id } }
      expects = (data[part] || []).map { |h| Inout.attributes_by_json(h, cls.to_sym) }
      indexs  = linouts.map { |r| { object: r, idx: expects.index { |o| o[:key] == r.key } } }
      removes = merge_lastest_with_expects(lastest, expects)
      arrange = rearrange(lastest, part)
      changes = []

      indexs.each do |rx|
        next if rx[:idx].nil?
        changed_attrs, new_attrs = rx[:object].changes_by_expect(data[part][rx[:idx]])
        next if changed_attrs.size == 0

        idx = arrange.index { |o| o[:id] == changed_attrs[:id] }
        if idx.nil?
          changes << changed_attrs
        else
          arrange[idx].merge!(changed_attrs)
          unless new_attrs.nil?
            arrange[idx][:has_discarded_flag] = true
            new_attrs[:position] = arrange[idx][:position]
          end
        end
        changes << new_attrs unless new_attrs.nil?
      end
      inout_jsons += removes + arrange + changes
    end
    attrs[:inouts_attributes] = inout_jsons if inout_jsons.length > 0

    attrs[:id] = self.id if attrs.size > 0
    attrs
  end

  protected

  # def generate_key
  #   self.key = Digest::MD5.hexdigest("#{self.method}|#{self.path}")
  # end
end
