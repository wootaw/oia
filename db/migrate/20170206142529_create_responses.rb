class CreateResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :responses do |t|
      t.string      :name
      t.integer     :location
      t.string      :group
      t.string      :data_type
      t.string      :summary
      t.boolean     :array, default: false
      t.string      :ancestor, index: true
      t.string      :options
      t.integer     :version, default: 1, index: true
      t.integer     :discard_version, index: true
      t.string      :key, index: true
      t.integer     :state, index: true
      t.integer     :position, index: true
      t.references  :resource, index: true
      t.timestamps
    end
  end
end
