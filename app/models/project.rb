class Project < ApplicationRecord
  include AASM
  include Versionable

  belongs_to :owner, polymorphic: true

  has_one :lastest_change, -> { order 'position DESC' }, class_name: 'Change'

  has_many :documents, dependent: :destroy
  has_many :version_changes, dependent: :destroy, class_name: 'Change'

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }, uniqueness: { scope: :owner }
  validates :key, presence: true, uniqueness: true
  validates :token, presence: true

  accepts_nested_attributes_for :documents

  # enum state: {
  #   mounted: 1,
  #   running: 99
  # }

  # aasm column: :state, enum: true do
  #   state :mounted, initial: true
  #   state :running
  # end

  def version_number
    "#{major_version}.#{minor_version}.#{patch_version}.#{changes_version}"
  end

  def update_version(params)
    changes, docs_attrs = update_documents(params)

    if changes[:minor] > 0
      self.minor_version += 1
      self.patch_version = 0
      self.changes_version = 0
    elsif changes[:patch] > 0
      self.patch_version += 1
      self.changes_version = 0
    elsif changes[:changes] > 0
      self.changes_version += 1
    end

    change = self.lastest_change
    unless changes[:minor] + changes[:patch] + changes[:changes] == 0
      number = change.nil? ? 1 : change.position + 1
      self.attach_version(docs_attrs, number)
      self.version_changes.build(version: self.version_number)
    end

    # ap docs_attrs
    self.assign_attributes(documents_attributes: docs_attrs)
  end

  def attach_version(attrs, number)
    attrs.each do |doc|
      doc[:version] = number unless doc.has_key?(:id)
    end
  end

  def update_documents(doc_params)
    results = { minor: 0, patch: 0, changes: 0 }
    docs_attrs = doc_params.map do |attrs|
      attrs.symbolize_keys!
      doc_attrs = attrs.slice(:name, :summary)

      doc = self.documents.where("name = ? OR summary = ?", attrs[:name], attrs[:summary]).take
      descs = if doc.nil?
        results[:minor] += 1
        []
      else
        doc_attrs.merge!({ id: doc.id })
        change = self.lastest_change
        change.nil? ? [] : change.parts(doc, :descriptions)
      end

      attrs[:descriptions].each_with_index do |row, i|
        str = row.join(" ").strip
        next if str.nil?
        next if !descs[i].nil? && Digest::MD5.hexdigest(str) == descs[i].key
        doc_attrs[:descriptions_attributes] = [] unless doc_attrs.has_key?(:descriptions_attributes)
        doc_attrs[:descriptions_attributes] << { content: str, position: i + 1, key: Digest::MD5.hexdigest(str) }
      end unless attrs[:descriptions].nil?

      doc_attrs
    end

    return results, docs_attrs
  end
end
