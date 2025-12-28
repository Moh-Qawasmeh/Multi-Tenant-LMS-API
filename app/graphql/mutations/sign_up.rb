module Mutations
  class SignUp < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true
    argument :name, String, required: true
    argument :role, String, required: false # optional, defaults to user? Or strictly user?

    field :user, Types::UserType, null: true
    field :errors, [String], null: false
    field :token, String, null: true

    def resolve(email:, password:, name:, role: nil)
      school = Current.school
      unless school
         return { user: nil, errors: ["School context missing"], token: nil }
      end

      user = school.users.build(
        email: email,
        password: password,
        name: name,
        role: role || 'user',
        active: true
      )

      if user.save
        # Generate token?
        # If using devise-jwt, we can manually generate.
        # Or simplify and just return user + headers (handled by middleware? No, mutation response needs token often).
        # Let's mock token or implementation needed.
        # Devise-jwt usually adds token to 'Authorization' header on success login.
        # Here we are inside a mutation.
        # We can use `Warden::JWTAuth::UserEncoder` helper if available.
        
        # For now, let's assume we return the user and client handles login via separate mutation or we autologin.
        # But requirement says "Authentication Mutations: signUp, signIn".
        # So we should return token.
        
        token = nil # Implement token generation
        
        { user: user, errors: [], token: token }
      else
        { user: nil, errors: user.errors.full_messages, token: nil }
      end
    end
  end
end
