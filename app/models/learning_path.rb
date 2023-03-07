class LearningPath < ApplicationRecord
  has_many :learning_path_enrollments
  has_many :student_profiles, through: :learning_path_enrollments
  has_and_belongs_to_many :courses
end
