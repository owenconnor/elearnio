class StudentProfile < ApplicationRecord
  belongs_to :user
  has_many :course_enrollments
  has_many :courses, through: :course_enrollments
  has_many :learning_path_enrollments
  has_many :learning_paths, through: :learning_path_enrollments
end
