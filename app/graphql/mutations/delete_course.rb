module Mutations
  class DeleteCourse < BaseMutation
    argument :id, ID, required: true

    field :course, Types::CourseType, null: true
    field :errors, [String], null: false

    def resolve(id:)
      course = Course.find_by(id: id)
      return { course: nil, errors: ["Course not found"] } unless course

      return { course: nil, errors: ["Unauthorized"] } unless context[:current_ability].can?(:destroy, course)

      if course.destroy
        { course: course, errors: [] }
      else
        { course: nil, errors: course.errors.full_messages }
      end
    end
  end
end
