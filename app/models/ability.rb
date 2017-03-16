class Ability
  include CanCan::Ability

  def initialize(user, owner)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    @owner = owner
    @user  = user

    if @user.blank?
      roles_for_anonymous
    else
      roles_for_members
    end
  end

  protected

  def roles_for_members
    roles_for_projects
    basic_read_only
  end

  def roles_for_anonymous
    cannot :manage, :all
    basic_read_only
  end

  def basic_read_only
    can :read, Project do |project|
      project.jpublic? || !@user.nil? && project.owner.is_a?(User) && project.owner_id == @user.id
    end
  end

  def roles_for_projects
    can :manage, Project do |project|
      if project.owner.nil?
        false
      elsif project.owner.is_a?(User)
        project.owner_id == @user.id
      end
    end
  end
end
