class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.references :team, index: true
      t.references :user, index: true
      t.timestamps
    end
  end
end
