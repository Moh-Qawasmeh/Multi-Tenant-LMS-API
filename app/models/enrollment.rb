class Enrollment < ApplicationRecord
  default_scope { where(school_id: Current.school&.id) }
  belongs_to :school
  belongs_to :user
  belongs_to :course

  validates :user_id, uniqueness: { scope: :course_id }
end
