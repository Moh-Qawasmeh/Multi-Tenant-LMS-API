# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    return unless user.school_id == Current.school&.id

    if user.admin?
      can :manage, :all
    elsif user.instructor?
      can :read, Course
      can :update, Course
      can :read, User
      can :read, Enrollment
      can :update, User, id: user.id
    else
      # Basic User
      can :read, Course
      can :read, User, id: user.id
      can :update, User, id: user.id
      can :read, Enrollment, user_id: user.id
      can :create, Enrollment, user_id: user.id
    end
  end
end
