module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Current User
    field :current_user, Types::UserType, null: true, description: "The currently authenticated user"
    def current_user
      context[:current_user]
    end

    # Users (Admin/Instructor)
    field :users, [Types::UserType], null: false, description: "List of users"
    def users
      # CanCanCan should handle filtering via `accessible_by` usually, or we check manually
      # But ability.rb defines `can :read, User`. 
      # With `accessible_by(current_ability)` we can filter.
      User.accessible_by(context[:current_ability])
    end

    # User (Admin/Instructor or Self)
    field :user, Types::UserType, null: true do
      argument :id, ID, required: true
    end
    def user(id:)
      User.accessible_by(context[:current_ability]).find_by(id: id)
    end

    # Courses (Authenticated users)
    field :courses, [Types::CourseType], null: false
    def courses
      Course.accessible_by(context[:current_ability])
    end

    field :course, Types::CourseType, null: true do
      argument :id, ID, required: true
    end
    def course(id:)
      Course.accessible_by(context[:current_ability]).find_by(id: id)
    end

    # Enrollments
    field :enrollments, [Types::EnrollmentType], null: false
    def enrollments
      Enrollment.accessible_by(context[:current_ability])
    end

    field :enrollment, Types::EnrollmentType, null: true do
      argument :id, ID, required: true
    end
    def enrollment(id:)
      Enrollment.accessible_by(context[:current_ability]).find_by(id: id)
    end
  end
end
