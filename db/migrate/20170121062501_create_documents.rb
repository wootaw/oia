class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.string      :name, index: true
      t.string      :summary
      t.string      :custom_state
      t.string      :custom_state_summary
      t.integer     :state, index: true
      t.datetime    :changed_at
      t.integer     :position, index: true
      t.integer     :version, default: 0, index: true
      t.references  :project, index: true
      t.timestamps
    end
  end
end
