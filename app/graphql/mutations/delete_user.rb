module Mutations
  class DeleteUser < BaseMutation
    argument :id, ID, required: true

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(id:)
      user = User.find_by(id: id)
      return { user: nil, errors: ["User not found"] } unless user

      return { user: nil, errors: ["Unauthorized"] } unless context[:current_ability].can?(:destroy, user)

      if user.destroy
        { user: user, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end
  end
end
