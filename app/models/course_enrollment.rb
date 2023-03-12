class CourseEnrollment < ApplicationRecord
  belongs_to :course
  belongs_to :student_profile

  validates :course_id, presence: true
  validates :student_profile_id, presence: true
  validates :course_id, uniqueness: { scope: :student_profile_id }
  validates :status, inclusion: { in: %w(enrolled completed) }

  validate :student_profile_is_not_already_enrolled_in_course, on: :create

  def student_profile_is_not_already_enrolled_in_course
    if CourseEnrollment.where(course: course, student_profile: student_profile).any?
      errors.add(:student_profile, "is already enrolled in this course")
    end
  end
end

