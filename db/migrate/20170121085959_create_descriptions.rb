class CreateDescriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :descriptions do |t|
      t.text        :content
      t.integer     :version, default: 0, index: true
      t.references  :owner, polymorphic: true, index: true
      t.timestamps
    end
  end
end
