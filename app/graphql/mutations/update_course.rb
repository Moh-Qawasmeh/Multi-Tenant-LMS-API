module Mutations
  class UpdateCourse < BaseMutation
    argument :id, ID, required: true
    argument :title, String, required: false
    argument :description, String, required: false

    field :course, Types::CourseType, null: true
    field :errors, [String], null: false

    def resolve(id:, title: nil, description: nil)
      course = Course.find_by(id: id)
      return { course: nil, errors: ["Course not found"] } unless course


      return { course: nil, errors: ["Unauthorized"] } unless context[:current_ability].can?(:update, course)

      if course.update(title: title || course.title, description: description || course.description)
        { course: course, errors: [] }
      else
        { course: nil, errors: course.errors.full_messages }
      end
    end
  end
end
