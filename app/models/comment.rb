class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :target, polymorphic: true
  belongs_to :reply, class_name: "Comment", foreign_key: "reply_id"

  acts_as_list scope: [:target_id, :target_type]
end
