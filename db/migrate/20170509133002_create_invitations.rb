class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.string      :email
      t.string      :key
      t.timestamps
    end

    add_index :invitations, :key, unique: true
  end
end
