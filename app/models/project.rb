class Project < ApplicationRecord
  include AASM
  include Versionable
  include DocumentUpdate

  belongs_to :owner, polymorphic: true

  has_one :lastest_change, -> { order 'position DESC' }, class_name: 'Change'

  has_many :documents, dependent: :destroy
  has_many :tapes, dependent: :destroy
  has_many :collaborators, dependent: :destroy
  has_many :version_changes, dependent: :destroy, class_name: 'Change'

  has_many :resources, through: :documents

  has_many :signed_collaborators, -> { where "collaborators.member_type = 'User'" }, class_name: "Collaborator"
  has_many :unsign_collaborators, -> { where "collaborators.member_type = 'Invitation'" }, class_name: "Collaborator"

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }, uniqueness: { scope: :owner }
  # validates :summary, presence: true
  validates :access_key, presence: true, uniqueness: true
  validates :secret_key, presence: true
  validates :clazz, presence: true

  accepts_nested_attributes_for :documents
  current_set :documents

  enum clazz: {
    jpublic:  40,
    jprivate: 90
  }

  # aasm column: :state, enum: true do
  #   state :mounted, initial: true
  #   state :running
  # end

  def version_number
    "#{major_version}.#{minor_version}.#{patch_version}.#{changes_version}"
  end

  def assign_keys
    if access_key.nil? || secret_key.nil?
      self.access_key = SecureRandom.hex(12)
      self.secret_key = SecureRandom.hex(12)
    end
  end

  def append_collaborators(user, emails)
    signed_users  = User.where(email: emails)
    unsign_emails = emails - signed_users.map(&:email)

    added_user_ids = signed_collaborators.where(member_id: signed_users).map do |added_user_collaborator|
      added_user_collaborator.back! if added_user_collaborator.left? || added_user_collaborator.declined?
      added_user_collaborator.member_id
    end

    signed_users.each do |signed_user|
      unless added_user_ids.include?(signed_user.id)
        collaborators.create(member: signed_user, user: user)
      end
    end

    invited_collaborators = unsign_collaborators
    invited_collaborators = invited_collaborators.joins("INNER JOIN invitations ON invitations.id = collaborators.member_id")
    invited_collaborators = invited_collaborators.where("invitations.email IN (?)", unsign_emails)

    invited_emails = invited_collaborators.map do |invited_collaborator|
      invited_collaborator.back! if invited_collaborator.declined?
      invited_collaborator.member.email
    end

    (unsign_emails - invited_emails).each do |email|
      invitation = Invitation.new(email: email)
      begin
        invitation.key = SecureRandom.hex
      end while Invitation.exists?(key: invitation.key)
      collaborators.create(member: invitation, user: user)
    end
  end
end
