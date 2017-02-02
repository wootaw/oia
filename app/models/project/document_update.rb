class Project
  module DocumentUpdate
    extend ActiveSupport::Concern

    def update_version(params)
      changes = { minor: 0, patch: 0, changes: 0 }
      docs_attrs = documents_attributes_by_json(params)

      docs_attrs.map do |doc_attrs|
        changes[:minor] += 1 unless doc_attrs.has_key?(:id)
        changes[:changes] += 1 if doc_attrs.has_key?(:descriptions_attributes)

        doc_attrs[:resources_attributes].each do |res_attrs|
          changes[:patch] += 1 unless res_attrs.has_key?(:id)
          changes[:changes] += 1 if res_attrs.has_key?(:descriptions_attributes)
        end if doc_attrs.has_key?(:resources_attributes)
      end

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
      attrs.each do |o|
        o.each do |k, data|
          attach_version(o[k], number) if /s\_attributes\Z/ === k
        end

        if o.has_key?(:id)
          o[:discard_version] = number if o.size == 1
        else
          o[:version] = number
        end
      end unless attrs.nil?
    end

    def documents_attributes_by_json(doc_params)
      doc_params.map do |attrs|
        attrs.symbolize_keys!

        doc = self.documents.where("name = ? OR summary = ?", attrs[:name], attrs[:summary]).take
        if doc.nil?
          Document.attributes_by_json(attrs)
        else
          doc.changes_by_expect(attrs)
        end
      end
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
            descriptions: new_jsons(res, :descriptions),
            headers: new_jsons(res, :headers),
            parameters: new_jsons(res, :parameters),
            responses: new_jsons(res, :responses)
          })
        end
      when /\Aheaders|parameters|responses\Z/
        data.map do |o|
          o.symbolize_keys!
          o.slice(:name, :group, :type, :summary, :required, :array, :default, :options).merge({
            key: Digest::MD5.hexdigest("#{part}|#{(o[:parent] || []).join(',')}|#{o[:name]}"),
            descriptions: new_jsons(o, :descriptions)
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
      results += resource_changes(lastest, expects) if part == :resources
      return results, lastest
    end

    def resource_changes(lastest, expects)
      results = []
      lastest.each do |o|
        if o[:id].nil?
          desc_jsons = rearrange(o[:descriptions], nil, :descriptions)
          o[:descriptions_attributes] = desc_jsons if desc_jsons.length > 0
          o.except!(:descriptions, :headers, :parameters, :responses)
        else
          resource = expects.delete_at(expects.index { |e| e[:key] == o[:key] })
          changed  = o[:object].changes_with_expect(resource)
          results << changed if changed.size > 0
          o.delete(:object)
        end
      end
      results
    end

  end
end
