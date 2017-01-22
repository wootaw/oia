class CreateChanges < ActiveRecord::Migration[5.0]
  def change
    create_table :changes do |t|
      t.string      :version
      t.integer     :position, index: true
      t.integer     :state, index: true
      t.references  :project, index: true
      t.timestamps
    end
  end
end
