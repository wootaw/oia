class Project
  module DocumentUpdate
    extend ActiveSupport::Concern

    def update_version(params)
      changes, docs_attrs = update_documents(params)

      # ap changes
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
        # ap version_number
        self.version_changes.build(version: self.version_number)
      end

      # ap docs_attrs
      self.assign_attributes(documents_attributes: docs_attrs)
    end

    def attach_version(attrs, number)
      attrs.each do |doc|
        doc[:version] = number unless doc.has_key?(:id)
        attr_version(doc, :descriptions_attributes, number)
        attr_version(doc, :resources_attributes, number)
      end
    end

    def attr_version(json, field, number)
      json[field].each do |attrs|
        attr_version(attrs, :descriptions_attributes, number) unless field == :descriptions_attributes

        if attrs.has_key?(:id)
          attrs[:discard_version] = number if attrs.size == 1
        else
          attrs[:version] = number
        end
      end unless json[field].nil?
    end

    def update_documents(doc_params)
      results = { minor: 0, patch: 0, changes: 0 }
      change  = self.lastest_change

      docs_attrs = doc_params.map do |attrs|
        attrs.symbolize_keys!
        doc_attrs = attrs.slice(:name, :summary)

        doc = self.documents.where("name = ? OR summary = ?", attrs[:name], attrs[:summary]).take
        if doc.nil?
          results[:minor] += 1
        else
          doc_attrs.merge!({ id: doc.id })
        end

        desc_jsons = attribute_jsons(change, doc, attrs, :descriptions)
        unless desc_jsons.length == 0
          doc_attrs[:descriptions_attributes] = desc_jsons
          results[:changes] += 1
        end

        res_jsons = attribute_jsons(change, doc, attrs, :resources)
        unless res_jsons.length == 0
          res_jsons.each do |r|
            if r.has_key?(:id)
              results[:changes] += 1
            else
              results[:minor] += 1
              break
            end

            # desc_jsons = attribute_jsons(change, doc, attrs, :descriptions)
          end
          doc_attrs[:resources_attributes] = res_jsons
        end
        doc_attrs
      end

      return results, docs_attrs
    end

    def new_jsons(attrs, part)
      data = attrs[part] || []
      case part
      when :descriptions
        data.map { |row| row.join(" ").strip }.compact.map do |s|
          { key: Digest::MD5.hexdigest(s), content: s }
        end
      when :resources
        data.map do |res|
          res.symbolize_keys!
          res.slice(:path, :summary).merge({ 
            key: Digest::MD5.hexdigest("#{res[:method].upcase}|#{res[:path]}"),
            method: res[:method].upcase,
            descriptions: new_jsons(res, :descriptions)
          })
        end
      end
    end

    def old_jsons(change, item, part)
      data = item.nil? || change.nil? ? [] : change.parts(item, part)
      case part
      when :descriptions
        data.map { |o| { key: o.key, position: o.position, id: o.id } }
      when :resources
        data.map do |o| 
          { 
            key: o.key, 
            position: o.position, 
            id: o.id, 
            summary: o.summary,
            descriptions: old_jsons(change, o, :descriptions),
            object: o
          }
        end
      end
    end

    def attribute_jsons(change, item, attrs, part)
      results, lastest = will_lastest(change, item, attrs, part)
      results + rearrange(lastest, item, part)
    end

    def will_lastest(change, item, attrs, part)
      lastest = old_jsons(change, item, part)
      expects = new_jsons(attrs, part)
      results = merge_lastest_with_expects(lastest, expects)

      case part
      when :resources
        lastest.each do |o|
          # rlastest = 
          rlastest = o[:descriptions]
          if o[:id].nil?
            # rlastest = o[:descriptions]
            desc_jsons = rearrange(rlastest, nil, :descriptions)
            o[:descriptions_attributes] = desc_jsons if desc_jsons.length > 0
          else
            res = expects.delete_at(expects.index { |e| e[:key] == o[:key] })

            changed = {}
            changed.merge!({ id: o[:id], summary: res[:summary] }) unless res[:summary] == o[:summary]

            
            desc_jsons = merge_lastest_with_expects(rlastest, res[:descriptions])
            desc_jsons += rearrange(rlastest, o[:object], :descriptions)
            changed.merge!({ id: o[:id], descriptions_attributes: desc_jsons }) if desc_jsons.length > 0

            # results << res.slice(:summary).merge({ id: o[:id] }) unless res[:summary] == o[:summary]
            results << changed if changed.size > 0
          end
          o.delete_if { |k, v| k == :descriptions || k == :object }
          # o.
          # next if o[:id].nil?
          
        end
      end

      return results, lastest
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

    def rearrange(lastest, item, part)
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
              expand  = stack.length * 10
              if expands.nil?
                moves   = item.send(part).where("position >= ?", o[:position])
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
