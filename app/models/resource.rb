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

  def changes_with_expect(expect)
    changed = {}
    change  = self.lastest_change

    changed[:summary] = expect[:summary] unless expect[:summary] == self.summary

    rdesc_lastest = change.parts(self, :descriptions).map { |o| { key: o.key, position: o.position, id: o.id } }
    desc_jsons = merge_lastest_with_expects(rdesc_lastest, expect[:descriptions])
    desc_jsons += rearrange(rdesc_lastest, self, :descriptions)
    changed[:descriptions_attributes] = desc_jsons if desc_jsons.length > 0

    changed[:id] = self.id if changed.size > 0
    changed
  end

  protected

  # def generate_key
  #   self.key = Digest::MD5.hexdigest("#{self.method}|#{self.path}")
  # end
end
