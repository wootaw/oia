class CreateCollaborators < ActiveRecord::Migration[5.0]
  def change
    create_table :collaborators do |t|
      t.integer     :state, index: true
      t.datetime    :left_at
      t.references  :user, index: true
      t.references  :project, index: true
      t.references  :member, polymorphic: true, index: true
      t.timestamps
    end
  end
end
