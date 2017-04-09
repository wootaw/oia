class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text        :body, null: false
      t.datetime    :deleted_at, index: true
      t.integer     :reply_id
      t.integer     :position, index: true
      t.references  :user, index: true
      t.references  :target, polymorphic: true, index: true
      t.timestamps
    end
  end
end
