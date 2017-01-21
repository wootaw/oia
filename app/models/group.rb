class Group < ApplicationRecord
  belongs_to :team

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }, uniqueness: { scope: :team }
end
