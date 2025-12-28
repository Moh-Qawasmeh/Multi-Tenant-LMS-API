class School < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_many :enrollments, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2 }
  validates :subdomain,
            presence: true,
            uniqueness: true,
            format: { with: /\A[a-z0-9]{3,20}\z/ }
end