module Mutations
  class CreateUser < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true
    argument :name, String, required: true
    argument :role, String, required: true
    argument :active, Boolean, required: false

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(email:, password:, name:, role:, active: true)
      return { user: nil, errors: ["Unauthorized"] } unless context[:current_ability].can?(:create, User) || context[:current_ability].can?(:manage, User)

      school = Current.school
      user = school.users.build(
        email: email, 
        password: password, 
        name: name, 
        role: role, 
        active: active
      )

      if user.save
        { user: user, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end
  end
end
