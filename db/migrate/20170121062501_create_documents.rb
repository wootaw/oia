class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.string      :name, index: true
      t.string      :summary
      t.string      :custom_state
      t.string      :custom_state_summary
      t.string      :aasm_state, index: true
      t.references  :project, index: true
      t.timestamps
    end
  end
end
