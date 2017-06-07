# Define abilities for the passed in user here
class Ability

  include CanCan::Ability

  def initialize(user)

    # Everyone
    can :read, ActiveAdmin::Page, name: "Dashboard"

    # System Administrators
    if user.has_role? :admin
      can :manage, :all
      return
    end

    # Head of programming
    if user.has_role? :programming
      can :manage, Show
      can :manage, Schedule
    end

    # Committee members
    if user.has_role? :committee
      can :manage, Tag
      can [:read, :update], Page
      can :manage, SubPage
      can :manage, Event
    end

    if user.has_role? :publisher
      can :manage, Tag
    end

    # Hosts (their role is implicit)
    can [:read, :update], Show, :id => Show.of_user(user).map(&:id)
    can [:read, :update, :destroy], Podcast, :id => Podcast.of_user(user).map(&:id)
    can :create, Podcast

    # TODO: create permissions for posts
  end

end
