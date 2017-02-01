module Versionable
  extend ActiveSupport::Concern

  included do
    # enum state: {
    #   latest: 1,
    #   dated: 50,
    #   discarded: 99
    # }

    # aasm column: :state, enum: true do
    #   state :latest, initial: true
    #   state :dated, :discarded

    #   event :replace do
    #     transitions from: :latest, to: :dated
    #   end

    #   event :discard do
    #     transitions from: :latest, to: :discarded
    #   end

    # end

    def self.init_descriptions(data, attrs)
      desc_lastest = Description.expects(data)
      desc_lastest.each_with_index { |d, i| d[:position] = 1000 * i }
      attrs[:descriptions_attributes] = desc_lastest unless desc_lastest.length == 0
    end

    def list_by_version(set, number)
      recs = self.send(set)
      recs = recs.where("version <= ? AND (discard_version IS NULL OR discard_version IS NOT NULL AND discard_version > ?)", number, number)
      max  = recs.select("MAX(version) AS mv, position").group(:position)
      recs.joins("
        INNER JOIN (#{max.to_sql}) AS maxpos ON maxpos.mv = #{set}.version AND maxpos.position = #{set}.position
      ").order(:position)
    end

    def replace_descriptions(data, attrs)
      descs  = lastest_change.nil? ? [] : lastest_change.parts(self, :descriptions)
      desc_lastest = descs.map { |o| { key: o.key, position: o.position, id: o.id } }
      desc_expects = Description.expects(data)
      desc_removes = merge_lastest_with_expects(desc_lastest, desc_expects)
      desc_arrange = rearrange(desc_lastest, :descriptions)
      attrs[:descriptions_attributes] = desc_removes + desc_arrange if desc_removes.length + desc_arrange.length > 0
    end

    def merge_lastest_with_expects(lastest, expects)
      removes = []
      HashDiff.diff(lastest.map { |o| o[:key] }, expects.map { |o| o[:key] }).each do |diff|
        idx = /\[(\d+)\]/.match(diff[1])[1].to_i
        if diff[0] == "+"
          lastest.insert(idx, expects.delete_at(expects.index { |o| o[:key] == diff[2] }))
        elsif diff[0] == "-"
          removes << lastest.delete_at(idx).slice(:id)
        end
      end
      removes
    end

    def rearrange(lastest, part)
      stack   = []
      step    = 1000
      move    = 0
      expands = nil
      results = []

      lastest.each do |o|
        if o[:position].nil? || stack.length == 0
          stack.push(o)
          next
        elsif stack.last[:position].nil?
          unless stack[0][:position].nil?
            if o[:position] + move - stack[0][:position] < stack.length
              expand = stack.length * 10
              if expands.nil?
                moves   = self.send(part).where("position >= ?", o[:position])
                expands = moves.map { |d| { id: d.id, position: d.position + expand } }
              else
                expands.each { |d| d[:position] += expand if d[:position] >= o[:position] + move }
              end
              move += expand
            end
            step = (o[:position] + move - stack[0][:position]) / stack.length
          end

          stack.reverse.each_with_index do |d, i|
            results << d.merge!({ position: o[:position] + move - step * (i + 1) }) if d[:position].nil?
          end
          stack = [o]
        else
          stack[0] = o
        end

        stack[0][:position] += move
      end

      start = stack[0].nil? || stack[0][:position].nil? ? 0 : stack[0][:position]
      stack.each_with_index do |d, i|
        results << d.merge!({ position: start + 1000 * i }) if d[:position].nil?
      end

      expands.each { |d| results << d } unless expands.nil?
      results
    end

  end
end