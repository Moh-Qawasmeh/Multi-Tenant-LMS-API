class Course < ApplicationRecord
  default_scope { where(school_id: Current.school&.id) }
  belongs_to :school
  has_many :enrollments, dependent: :destroy
  has_many :enrolled_users, through: :enrollments, source: :user

  validates :title, presence: true, length: { minimum: 3 }
end
