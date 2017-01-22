class User < ApplicationRecord
  include AASM
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :members, dependent: :destroy
  has_many :personal_projects, as: :owner, dependent: :destroy, class_name: "Project"

  has_many :teams, through: :members, source: :team
  has_many :team_projects, through: :teams, source: :projects
  has_many :roles, through: :members, source: :roles
  has_many :groups, through: :roles, source: :group

  enum state: {
    mounted: 1,
    running: 99
  }

  aasm column: :state, enum: true do
    state :mounted, initial: true
    state :running
  end
end
