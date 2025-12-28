class User < ApplicationRecord
  default_scope { where(school_id: Current.school&.id) }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :database_authenticatable, :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist

  belongs_to :school
  has_many :enrollments, dependent: :destroy
  has_many :enrolled_courses, through: :enrollments, source: :course

  enum role: { user: 0, instructor: 1, admin: 2 }

  validates :email, uniqueness: { scope: :school_id }
  validates :password, length: { minimum: 8 }, if: :password_required?

end

