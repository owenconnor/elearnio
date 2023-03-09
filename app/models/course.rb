class Course < ApplicationRecord
  belongs_to :author_profile
  has_many :course_enrollments
  has_many :student_profiles, through: :course_enrollments
  has_and_belongs_to_many :learning_paths

  validates :title, presence: true
  validates :author_profile_id, numericality: { only_integer: true }, presence: true

  def enrolled_students
    student_profiles
  end

  def enroll_student(student_profile)
    begin
      course_enrollments.create(student_profile: student_profile)
    rescue
      Rails.logger.info "Error: #{a} -------"
      Rails.logger.info a.errors.full_messages
    end
  end

  # Not crud
  def unenroll_student(student_profile)
    course_enrollments.where(student_profile: student_profile).destroy_all
  end

end
