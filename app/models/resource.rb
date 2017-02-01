class Resource < ApplicationRecord
  include AASM
  include Versionable

  belongs_to :document

  has_many :inouts, dependent: :destroy
  has_many :descriptions, as: :owner, dependent: :destroy

  has_many :headers,    -> { where clazz: :header },    class_name: "Inout"
  has_many :parameters, -> { where clazz: :parameter }, class_name: "Inout"
  has_many :responses,  -> { where clazz: :response },  class_name: "Inout"

  delegate :project, to: :document, prefix: false
  delegate :lastest_change, to: :project, prefix: false

  validates :method, :path, presence: true
  validates :key, presence: true, uniqueness: { scope: :document_id }
  validates :summary, presence: true, length: { minimum: 2, maximum: 50 }, uniqueness: { scope: :document_id }

  # acts_as_list scope: [:document_id]

  # before_create :generate_key

  enum method: %i(GET HEAD POST PUT DELETE PATCH TRACE OPTIONS CONNECT)

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

    attrs
  end

  def changes_by_expect(data)
    attrs = {}
    attrs[:summary] = data[:summary] unless self.summary == data[:summary]
    replace_descriptions(data, attrs)

    attrs[:id] = self.id if attrs.size > 0

    # ap attrs
    attrs
  end

  def changes_with_expect(expect)
    changed = {}
    change  = self.lastest_change

    Inout::clazzs.each do |cls|
      set = cls.to_s.tableize.to_sym
      param_lastest = change.parts(self, set).map do |o|
        r = o.attributes.symbolize_keys.slice(:id, :name, :group, :type, :summary, :required, :array, :default, :options, :key, :position)

        pdesc_lastest = change.parts(o, :descriptions)
        # pdesc_expects = expect[set].delete(:descriptions)
        pdesc_jsons = merge_lastest_with_expects(pdesc_lastest, pdesc_expects)
        pdesc_jsons += rearrange(pdesc_lastest, self, :descriptions)
      end



      param_json = merge_lastest_with_expects(param_lastest, expect[set])
      param_json += rearrange(param_lastest, self, set)
    end

    
    changed[:summary] = expect[:summary] unless expect[:summary] == self.summary

    rdesc_lastest = change.parts(self, :descriptions).map { |o| o.attributes.symbolize_keys.slice(:id, :key, :position) }
    desc_jsons = merge_lastest_with_expects(rdesc_lastest, expect[:descriptions])
    desc_jsons += rearrange(rdesc_lastest, self, :descriptions)
    changed[:descriptions_attributes] = desc_jsons if desc_jsons.length > 0


    # if o[:id].nil?
    #       desc_jsons = rearrange(o[:descriptions], nil, :descriptions)
    #       o[:descriptions_attributes] = desc_jsons if desc_jsons.length > 0
    #       o.except!(:descriptions, :headers, :parameters, :responses)
    #     else
    #       resource = expects.delete_at(expects.index { |e| e[:key] == o[:key] })
    #       changed  = o[:object].changes_with_expect(resource)
    #       results << changed if changed.size > 0
    #       o.delete(:object)
    #     end

    changed[:id] = self.id if changed.size > 0
    changed
  end

  protected

  # def generate_key
  #   self.key = Digest::MD5.hexdigest("#{self.method}|#{self.path}")
  # end
end
