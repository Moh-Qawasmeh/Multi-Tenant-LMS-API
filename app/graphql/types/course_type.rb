# frozen_string_literal: true

module Types
  class CourseType < Types::BaseObject
    field :id, ID, null: false
    field :school_id, Integer, null: false
    field :title, String
    field :description, String
    field :enrollments, [Types::EnrollmentType], null: true
    field :enrolled_users, [Types::UserType], null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
