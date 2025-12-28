module Mutations
  class CreateEnrollment < BaseMutation
    argument :user_id, ID, required: true
    argument :course_id, ID, required: true

    field :enrollment, Types::EnrollmentType, null: true
    field :errors, [String], null: false

    def resolve(user_id:, course_id:)
      return { enrollment: nil, errors: ["Unauthorized"] } unless context[:current_ability].can?(:create, Enrollment) || context[:current_ability].can?(:manage, Enrollment)

      school = Current.school
      user = school.users.find_by(id: user_id)
      course = school.courses.find_by(id: course_id)

      return { enrollment: nil, errors: ["User not found"] } unless user
      return { enrollment: nil, errors: ["Course not found"] } unless course

      enrollment = Enrollment.new(user: user, course: course, school: school)

      if enrollment.save
        { enrollment: enrollment, errors: [] }
      else
        { enrollment: nil, errors: enrollment.errors.full_messages }
      end
    end
  end
end
