# Purpose: To create a join table between student_profiles and learning_paths
class LearningPathEnrollment < ApplicationRecord
  #@!attribute status
  #  @return [String] The status of the enrollment. Can be "subscribed" or "completed"
  # @return [LearningPath] The learning path the student is enrolled in.
  # @!attribute student_profile
  # @return [StudentProfile] The student profile of the student enrolled in the learning path.
  belongs_to :student_profile
  belongs_to :learning_path
end
