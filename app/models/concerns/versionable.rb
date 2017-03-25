module Versionable
  extend ActiveSupport::Concern

  included do

    def self.key_name(field)
      case field
      when :parameter
        :params
      when :flag
        :state
      else
        field.to_s.tableize.to_sym
      end
    end

    def self.init_association(data, attrs, field)
      lastest = case field
      when :description
        Description.expects(data)
      when :flag
        flag_attrs = Flag.attributes_by_json(data[:state] || {})
        flag_attrs.size == 0 ? [] : [flag_attrs]
      else
        (data[key_name(field)] || []).map { |r| field.to_s.classify.constantize.attributes_by_json(r) }
      end

      lastest.each_with_index { |r, i| r[:position] = 1000 * i } unless field == :flag
      attrs["#{field.to_s.tableize}_attributes".to_sym] = lastest unless lastest.length == 0
    end

    def self.current_set(*args)
      args.each do |m|
        self.class_eval <<-CODE
          def the_#{m}(change)
            list_by_version(:#{m}, change.position)
          end
        CODE
      end
    end

    def replace_descriptions(data, attrs)
      descs  = lastest_change.nil? ? [] : lastest_change.parts(self, :descriptions)
      desc_lastest = descs.map { |o| { key: o.key, position: o.position, id: o.id } }
      desc_expects = Description.expects(data)
      desc_removes = merge_lastest_with_expects(desc_lastest, desc_expects)
      desc_arrange = rearrange(desc_lastest, :descriptions)
      attrs[:descriptions_attributes] = desc_removes + desc_arrange if desc_removes.length + desc_arrange.length > 0
    end

    def replace_association(data, attrs, field)
      keyname = self.class.key_name(field)
      ass     = field.to_s.tableize.to_sym
      objects = lastest_change.nil? ? [] : lastest_change.parts(self, ass)
      lastest = objects.map { |o| { key: o.key, position: o.position, id: o.id } }
      expects = (data[keyname] || []).map { |r| field.to_s.classify.constantize.attributes_by_json(r) }
      indexs  = objects.map { |r| { object: r, idx: expects.index { |o| o[:key] == r.key } } }
      removes = merge_lastest_with_expects(lastest, expects)
      arrange = rearrange(lastest, ass)
      moves   = []

      indexs.each do |rx|
        next if rx[:idx].nil?
        changed_attrs, new_attrs = rx[:object].changes_by_expect(data[keyname][rx[:idx]])
        next if changed_attrs.size == 0

        idx = arrange.index { |o| o[:id] == changed_attrs[:id] }
        if idx.nil?
          moves << changed_attrs
        else
          arrange[idx].merge!(changed_attrs)
          unless new_attrs.nil?
            arrange[idx][:has_discarded_flag] = true
            new_attrs[:position] = arrange[idx][:position]
          end
        end
        moves << new_attrs unless new_attrs.nil?
      end

      if removes.length + arrange.length + moves.length > 0
        attrs["#{field.to_s.tableize}_attributes".to_sym] = removes + arrange + moves
      end
    end

    def raw_description(change)
      list_by_version(:descriptions, change.position).map(&:content).join("\n")
    end

    def list_by_version(set, number)
      recs = self.send(set)
      # tn   = recs.table_name
      recs = recs.where("#{set}.version <= ? AND (#{set}.discard_version IS NULL OR #{set}.discard_version IS NOT NULL AND #{set}.discard_version > ?)", number, number)
      max  = recs.select("MAX(#{set}.version) AS mv, #{set}.position").group(:position)
      
      recs.joins("
        INNER JOIN (#{max.to_sql}) AS maxpos ON maxpos.mv = #{set}.version AND maxpos.position = #{set}.position
      ").order(:position)
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