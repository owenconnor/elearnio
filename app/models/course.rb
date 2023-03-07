class Course < ApplicationRecord
  belongs_to :author_profile
  has_many :course_enrollments
  has_many :student_profiles, through: :course_enrollments
  has_and_belongs_to_many :learning_paths
end
