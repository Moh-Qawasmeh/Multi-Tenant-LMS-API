module Mutations
  class DeleteEnrollment < BaseMutation
    argument :id, ID, required: true

    field :enrollment, Types::EnrollmentType, null: true
    field :errors, [String], null: false

    def resolve(id:)
      enrollment = Enrollment.find_by(id: id)
      return { enrollment: nil, errors: ["Enrollment not found"] } unless enrollment

      return { enrollment: nil, errors: ["Unauthorized"] } unless context[:current_ability].can?(:destroy, enrollment)

      if enrollment.destroy
        { enrollment: enrollment, errors: [] }
      else
        { enrollment: nil, errors: enrollment.errors.full_messages }
      end
    end
  end
end
