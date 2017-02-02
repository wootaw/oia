class CreateResources < ActiveRecord::Migration[5.0]
  def change
    create_table :resources do |t|
      t.integer     :method
      t.string      :path, index: true
      t.string      :summary
      t.string      :custom_state
      t.string      :custom_state_summary
      t.integer     :state, index: true
      t.string      :key, index: true
      t.integer     :version, default: 1, index: true
      t.integer     :discard_version, index: true
      t.integer     :position, index: true
      t.references  :document, index: true
      t.timestamps
    end
  end
end
