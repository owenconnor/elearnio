class LearningPathEnrollment < ApplicationRecord
  belongs_to :student_profile
  belongs_to :learning_path
end
