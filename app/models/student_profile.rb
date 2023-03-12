class StudentProfile < ApplicationRecord
  belongs_to :user
  has_many :course_enrollments
  has_many :courses, through: :course_enrollments
  has_many :learning_path_enrollments
  has_many :learning_paths, through: :learning_path_enrollments

  def enrolled_courses
    course_enrollments.includes(:course).where(status: "enrolled").map(&:course)
  end

  def completed_courses
    course_enrollments.includes(:course).where(status: "completed").map(&:course)
  end
end
