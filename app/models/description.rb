class Description < ApplicationRecord
  include AASM

  belongs_to :owner, polymorphic: true

  validates :content, :version, :key, :position, presence: true, allow_blank: true

  # acts_as_list scope: [:owner_type, :owner_id]
  
  # enum state: {
  #   latest: 1,
  #   dated: 50,
  #   discarded: 99
  # }

  # aasm column: :state, enum: true do
  #   state :mounted, initial: true
  #   state :running
  # end

  def self.attributes_by_json(data)
    { key: Digest::MD5.hexdigest(data), content: data }
  end

  def self.expects(attrs)
    (attrs[:descriptions] || []).map { |row| row.join(" ").rstrip }.compact.map do |s|
      attributes_by_json(s)
    end
  end

  protected

end
