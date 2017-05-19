class User < ApplicationRecord
  include AASM
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :account

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:account]

  mount_uploader :avatar, AvatarUploader

  has_many :members, dependent: :destroy
  has_many :personal_projects, as: :owner, dependent: :destroy, class_name: "Project"
  has_many :collaborators, as: :member, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :teams, through: :members, source: :team
  has_many :team_projects, through: :teams, source: :projects
  has_many :roles, through: :members, source: :roles
  has_many :groups, through: :roles, source: :group

  validates_format_of :username, with: /\A[a-zA-Z0-9_-]*\Z/, multiline: true
  validates :username, presence: true, length: { minimum: 2, maximum: 50 }, uniqueness: true
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
