class Resource < ApplicationRecord
  include AASM
  include Versionable
  include Flagable

  belongs_to :document

  has_many :flags, as: :owner, dependent: :destroy
  has_many :parameters, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_many :descriptions, as: :owner, dependent: :destroy

  delegate :project, to: :document, prefix: false
  delegate :lastest_change, to: :project, prefix: false

  validates :method, :path, presence: true
  validates :key, presence: true, uniqueness: { scope: :document_id }
  validates :summary, presence: true, length: { minimum: 2, maximum: 50 }#, uniqueness: { scope: :document_id }
  validates :position, presence: true
  validates :slug, presence: true

  # acts_as_list scope: [:document_id]

  enum method: %i(GET HEAD POST PUT DELETE PATCH TRACE OPTIONS CONNECT)

  accepts_nested_attributes_for :flags
  accepts_nested_attributes_for :parameters
  accepts_nested_attributes_for :responses
  accepts_nested_attributes_for :descriptions

  # enum state: {
  #   mounted: 1,
  #   running: 99
  # }

  # aasm column: :state, enum: true do
  #   state :mounted, initial: true
  #   state :running
  # end

  def self.generate_slug(m, path)
    ([m.downcase] + path.split('/').select { |i| !i.blank? }.map { |e| e.gsub(/\A:/, '') }).join('-')
  end

  def self.attributes_by_json(data)
    data.symbolize_keys!
    attrs = data.slice(:path, :summary).merge({ 
      key: Digest::MD5.hexdigest("#{data[:method].upcase}|#{data[:path]}"),
      method: data[:method].upcase,
      slug: generate_slug(data[:method], data[:path])
    })
    [:description, :flag, :parameter, :response].each { |f| init_association(data, attrs, f) }
    attrs
  end

  def changes_by_expect(data)
    data.symbolize_keys!
    attrs = {}
    attrs[:summary] = data[:summary] unless self.summary == data[:summary]
    replace_descriptions(data, attrs)
    replace_flags(data, attrs)
    [:parameter, :response].each { |f| replace_association(data, attrs, f) }

    attrs[:id] = self.id if attrs.size > 0
    return attrs, nil
  end

  protected

end
