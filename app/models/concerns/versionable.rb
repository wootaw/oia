module Versionable
  extend ActiveSupport::Concern

  included do
    enum state: {
      latest: 1,
      dated: 50,
      discarded: 99
    }

    aasm column: :state, enum: true do
      state :latest, initial: true
      state :dated, :discarded

      event :replace do
        transitions from: :latest, to: :dated
      end

      event :discard do
        transitions from: :latest, to: :discarded
      end

    end

    def list_by_version(set, number)
      recs = self.send(set)
      recs = recs.where("version <= ? AND (discard_version IS NULL OR discard_version IS NOT NULL AND discard_version > ?)", number, number)
      max  = recs.select("MAX(version) AS mv, position").group(:position)
      recs.joins("
        INNER JOIN (#{max.to_sql}) AS maxpos ON maxpos.mv = #{set}.version AND maxpos.position = #{set}.position
      ").order(:position)
    end

  end
end