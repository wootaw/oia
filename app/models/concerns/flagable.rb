module Flagable
  extend ActiveSupport::Concern

  included do

    def replace_flags(data, attrs)
      flag_attrs = []
      lflag = lastest_change.nil? ? nil : lastest_change.parts(self, :flags).take
      if lflag.nil?
        changed_flag_attrs = Flag.attributes_by_json(data[:state] || {})
      else
        changed_flag_attrs, new_flag_attrs = lflag.changes_by_expect(data[:state] || {})
        flag_attrs << new_flag_attrs if !new_flag_attrs.nil? && new_flag_attrs.size > 0
      end
      flag_attrs << changed_flag_attrs if !changed_flag_attrs.nil? && changed_flag_attrs.size > 0
      attrs[:flags_attributes] = flag_attrs if flag_attrs.length > 0
    end
  end
end