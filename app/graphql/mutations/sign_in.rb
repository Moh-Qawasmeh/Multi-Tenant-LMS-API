module Mutations
  class SignIn < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :errors, [String], null: false

    def resolve(email:, password:)
      school = Current.school
      return { user: nil, token: nil, errors: ["School not found"] } unless school

      user = school.users.find_by(email: email)

      if user&.valid_password?(password)
        if user.active

           begin
             encoder = context[:request].env['warden-jwt_auth.encoder'] || Warden::JWTAuth::UserEncoder.new
             token = encoder.call(user, :user, nil).first
           rescue StandardError => e
             return { user: nil, token: nil, errors: ["Token generation failed: #{e.message}"] }
           end
           
           { user: user, token: token, errors: [] }
        else
           { user: nil, token: nil, errors: ["Account is inactive"] }
        end
      else
        { user: nil, token: nil, errors: ["Invalid credentials"] }
      end
    end
  end
end
