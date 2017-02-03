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

          res_attrs[:inouts_attributes].each do |inout_attrs|
            changes[:patch] += 1 unless inout_attrs.has_key?(:id)
            changes[:changes] += 1 if inout_attrs.has_key?(:descriptions_attributes)
          end if res_attrs.has_key?(:inouts_attributes)

        end if doc_attrs.has_key?(:resources_attributes)
      end

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
      self.assign_attributes(documents_attributes: docs_attrs)
    end

    def attach_version(attrs, number)
      attrs.each do |o|
        o.each do |k, data|
          attach_version(o[k], number) if /s\_attributes\Z/ === k
        end

        if o.has_key?(:id)
          o[:discard_version] = number if o.size == 1 || o.has_key?(:has_discarded_flag)
          o.delete(:has_discarded_flag)
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

  end
end
