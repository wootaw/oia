class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string      :name
      t.integer     :state, index: true
      t.references  :team, index: true
      t.timestamps
    end
  end
end
