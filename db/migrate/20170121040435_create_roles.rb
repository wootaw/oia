class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.references :member, index: true
      t.references :group, index: true
      t.timestamps
    end
  end
end
