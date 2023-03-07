class Course < ApplicationRecord
  belongs_to :author_profile
  has_many :enrollments
  has_many :student_profiles, through: :enrollments
end
