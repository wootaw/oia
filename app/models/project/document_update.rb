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
        doc[:descriptions_attributes].each do |desc_attrs|
          next if desc_attrs.has_key?(:position) && desc_attrs.has_key?(:id)
          desc_attrs[desc_attrs.has_key?(:id) ? :discard_version : :version] = number
        end unless doc[:descriptions_attributes].nil?
      end
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

        desc_jsons = description_jsons(change, doc, attrs, :descriptions)
        # ap desc_jsons
        unless desc_jsons.length == 0
          doc_attrs[:descriptions_attributes] = desc_jsons
          results[:changes] += 1
        end
        # attrs[:descriptions].each_with_index do |row, i|
        #   str = row.join(" ").strip
        #   next if str.nil?
        #   next if !descs[i].nil? && Digest::MD5.hexdigest(str) == descs[i].key
        #   doc_attrs[:descriptions_attributes] = [] unless doc_attrs.has_key?(:descriptions_attributes)
        #   doc_attrs[:descriptions_attributes] << { content: str, position: i + 1, key: Digest::MD5.hexdigest(str) }
        # end unless attrs[:descriptions].nil?

        doc_attrs
      end

      return results, docs_attrs
    end

    def description_jsons(change, item, attrs, part)
      results = []
      desc_lastest = item.nil? || change.nil? ? [] : change.parts(item, part)
      desc_expects = (attrs[part] || []).map { |row| row.join(" ").strip }.compact

      lastest = desc_lastest.map { |o| { key: o.key, position: o.position, id: o.id } }
      expects = desc_expects.map { |s| { key: Digest::MD5.hexdigest(s), content: s } }

      HashDiff.diff(lastest.map { |o| o[:key] }, expects.map { |o| o[:key] }).each do |diff|
        idx = /\[(\d+)\]/.match(diff[1])[1].to_i
        if diff[0] == "+"
          lastest.insert(idx, expects.delete_at(expects.index { |o| o[:key] == diff[2] }))
        elsif diff[0] == "-"
          results << lastest.delete_at(idx).slice(:id)
        end
      end

      stack = []
      step  = 1000
      move  = 0
      expands = nil
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
