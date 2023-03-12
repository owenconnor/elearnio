
# This model represents a student's enrollment in a course. It links a student profile to a course.
class CourseEnrollment < ApplicationRecord
  #@!attribute status
  #  @return [String] The status of the enrollment. Can be "enrolled" or "completed".
  # @!attribute id
  # @return [Integer] The ID of the enrollment.
  # @!attribute course
  # @return [Course] The course the student is enrolled in.
  # @!attribute student_profile
  # @return [StudentProfile] The student profile of the student enrolled in the course.

  belongs_to :course
  belongs_to :student_profile

  validates :course_id, presence: true
  validates :student_profile_id, presence: true
  validates :course_id, uniqueness: { scope: :student_profile_id }
  validates :status, inclusion: { in: %w(enrolled completed) }

end

