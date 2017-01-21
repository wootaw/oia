class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string      :name, index: true
      t.string      :aasm_state, index: true
      t.string      :key, index: true
      t.string      :token
      t.integer     :major_version, default: 0, index: true
      t.integer     :minor_version, default: 0, index: true
      t.integer     :patch_version, default: 0, index: true
      t.integer     :changes_version, default: 0, index: true
      t.references  :owner, polymorphic: true, index: true
      t.timestamps
    end
  end
end
