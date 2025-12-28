module Types
  class MutationType < Types::BaseObject
    # Authentication
    field :sign_up, mutation: Mutations::SignUp
    field :sign_in, mutation: Mutations::SignIn
    
    # Courses
    field :create_course, mutation: Mutations::CreateCourse
    field :update_course, mutation: Mutations::UpdateCourse
    field :delete_course, mutation: Mutations::DeleteCourse
    
    # Enrollments
    field :create_enrollment, mutation: Mutations::CreateEnrollment
    field :delete_enrollment, mutation: Mutations::DeleteEnrollment
    
    # Users
    field :create_user, mutation: Mutations::CreateUser
    field :update_user, mutation: Mutations::UpdateUser
    field :delete_user, mutation: Mutations::DeleteUser
  end
end
