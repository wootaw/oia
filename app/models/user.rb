class User < ApplicationRecord
  include AASM
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :account

  LOGIN_FORMAT = 'A-Za-z0-9\-\_\.'
  ALLOW_LOGIN_FORMAT_REGEXP = /\A[#{LOGIN_FORMAT}]+\z/

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:account]

  mount_uploader :avatar, AvatarUploader

  has_many :members, dependent: :destroy
  has_many :personal_projects, as: :owner, dependent: :destroy, class_name: "Project"
  has_many :collaborators, as: :member, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :participating_projects, through: :collaborators, source: :project
  has_many :teams, through: :members, source: :team
  has_many :team_projects, through: :teams, source: :projects
  has_many :roles, through: :members, source: :roles
  has_many :groups, through: :roles, source: :group

  validates_format_of :username, with: ALLOW_LOGIN_FORMAT_REGEXP, multiline: false
  validates :username, presence: true, length: { minimum: 2, maximum: 20 }, uniqueness: { case_sensitive: false }
  validates :username, exclusion: { in: A::RESERVED_WORDS, message: "%{value} is reserved." }
  validate :validate_username

  enum state: {
    mounted: 1,
    running: 99
  }

  aasm column: :state, enum: true do
    state :mounted, initial: true
    state :running
  end

  def view_projects(current_user)
    if !current_user.nil? && self.id == current_user.id
      self.participating_projects.where("collaborators.state = ?", Collaborator.states[:joined])
    else
      self.personal_projects.where(clazz: :jpublic)
    end
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if account = conditions.delete(:account)
      where(conditions.to_h).where("username = ? OR lower(email) = ?", account, account.downcase).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  protected

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end
end
