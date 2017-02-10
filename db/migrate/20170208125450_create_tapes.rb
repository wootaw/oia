class CreateTapes < ActiveRecord::Migration[5.0]
  def change
    create_table :tapes do |t|
      t.text        :content
      t.integer     :state, index: true
      t.integer     :version, index: true
      t.string      :schema
      t.references  :project, index: true
      t.timestamps
    end
  end
end
