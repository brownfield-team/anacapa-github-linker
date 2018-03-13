class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # https://github.com/RolifyCommunity/rolify/wiki/Devise---CanCanCan---rolify-Tutorial
    # see this tutorial for information about the Devise--CanCanCan--rolify stack
    if user.has_role? :admin
      # manage = perform any action
      # all = on everything
      can :manage, :all

    elsif user.has_role? :instructor
      can :create, Course
      # insturctors can only modify courses they have been granted access
      can :manage, Course , :id => Course.with_role(:instructor, user).pluck(:id)

      # a bit of a guess here... will need to test this.
      # can [:manage], RosterStudent, :parent => Course.with_role(:instructor, user)
      can :manage, RosterStudent
    elsif user.has_role? :ta
      #TAs can read Courses that they have been appointed to
      can :read, Course , :id => Course.with_role(:ta, user).pluck(:id)

      #TAs can create, read or update students that are part of a course they are a TA of
      can [:create, :read, :update], RosterStudent, :course_id => Course.with_role(:ta, user).pluck(:id)
      cannot [:view_ta, :update_ta], Course
    elsif user.has_role? :user
      can [:join, :leave], Course
      can :index, Course
      can :show, Course, :id => user.courses.pluck(:id)
    end

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
  end
end
