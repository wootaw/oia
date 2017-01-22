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
      t.integer     :version, default: 0, index: true
      t.datetime    :changed_at
      t.references  :document, index: true
      t.timestamps
    end
  end
end
