class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string      :name, index: true
      t.string      :summary
      t.integer     :state, index: true
      t.string      :access_key, index: true
      t.string      :secret_key
      t.integer     :major_version, default: 0, index: true
      t.integer     :minor_version, default: 0, index: true
      t.integer     :patch_version, default: 0, index: true
      t.integer     :changes_version, default: 0, index: true
      t.references  :owner, polymorphic: true, index: true
      t.timestamps
    end

    add_index :projects, [:name, :owner_id, :owner_type], unique: true
  end
end
