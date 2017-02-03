class CreateFlags < ActiveRecord::Migration[5.0]
  def change
    create_table :flags do |t|
      t.string      :name, index: true
      t.string      :summary
      t.integer     :version, default: 1, index: true
      t.integer     :discard_version, index: true
      t.integer     :position, index: true
      t.references  :owner, polymorphic: true, index: true
      t.timestamps
    end
  end
end
