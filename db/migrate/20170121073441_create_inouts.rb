class CreateInouts < ActiveRecord::Migration[5.0]
  def change
    create_table :inouts do |t|
      t.string      :clazz, index: true
      t.string      :name
      t.string      :group
      t.string      :type
      t.string      :summary
      t.boolean     :required
      t.boolean     :array
      t.integer     :parent_id, default: 0, index: true
      t.string      :default
      t.string      :options
      t.integer     :version, default: 1, index: true
      t.integer     :discard_version, index: true
      t.string      :key, index: true
      t.integer     :state, index: true
      t.integer     :position, index: true
      t.datetime    :changed_at
      t.references  :resource, index: true
      t.timestamps
    end
  end
end
