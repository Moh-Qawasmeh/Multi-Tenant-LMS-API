module Mutations
  class UpdateUser < BaseMutation
    argument :id, ID, required: true
    argument :name, String, required: false
    argument :password, String, required: false
    argument :role, String, required: false
    argument :active, Boolean, required: false

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(id:, name: nil, password: nil, role: nil, active: nil)
      user = User.find_by(id: id)
      return { user: nil, errors: ["User not found"] } unless user


      ability = context[:current_ability]
      return { user: nil, errors: ["Unauthorized"] } unless ability.can?(:update, user)

      current_user = context[:current_user]
      is_admin = current_user.admin?


      if (role.present? || !active.nil?) && !is_admin
         return { user: nil, errors: ["Unauthorized to update role or status"] }
      end

      updates = {}
      updates[:name] = name if name
      updates[:password] = password if password
      updates[:role] = role if role && is_admin
      updates[:active] = active if !active.nil? && is_admin

      if user.update(updates)
        { user: user, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end
  end
end
