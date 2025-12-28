module Mutations
  class CreateCourse < BaseMutation
    argument :title, String, required: true
    argument :description, String, required: false

    field :course, Types::CourseType, null: true
    field :errors, [String], null: false

    def resolve(title:, description: nil)
      
      course = school.courses.build(title: title, description: description)

      if course.save
        { course: course, errors: [] }
      else
        { course: nil, errors: course.errors.full_messages }
      end
    end
  end
end
