# Represents a course that can be taken by a student
class Course < ApplicationRecord
  # @!attribute [r] id
  #   @return [Integer] the unique identifier for the course
  # @!attribute [rw] title
  #   @return [String] the title of the course
  # @!attribute [rw] author_profile_id
  #   @return [Integer] the unique identifier for the author of the course
  # @!attribute [rw] created_at
  #   @return [DateTime] the date and time the course was created
  # @!attribute [rw] updated_at
  #   @return [DateTime] the date and time the course was last updated
  # @!attribute [rw] course_enrollments
  #   @return [Array<CourseEnrollment>] the course enrollments for the course
  # @!attribute [rw] student_profiles
  #   @return [Array<StudentProfile>] the student profiles that are enrolled in the course
  # @!attribute [rw] learning_paths
  #   @return [Array<LearningPath>] the learning paths that the course is a part of

  belongs_to :author_profile
  has_many :course_enrollments
  has_many :student_profiles, through: :course_enrollments
  has_and_belongs_to_many :learning_paths

  validates :title, presence: true
  validates :author_profile_id, numericality: { only_integer: true }, presence: true

  scope :by_author, -> (author_profile_id) { where(author_profile_id: author_profile_id) }
  scope :by_learning_path, -> (learning_path_id) { joins(:learning_paths).where(learning_paths: { id: learning_path_id }) }
  scope :completed_by_student, -> (student_profile_id) { joins(:course_enrollments).where(course_enrollments: { student_profile_id: student_profile_id, status: "completed" }) }
  scope :active_courses_by_student, -> (student_profile_id) { joins(:course_enrollments).where(course_enrollments: { student_profile_id: student_profile_id, status: "enrolled" }) }


  def enrolled_students
    student_profiles
  end

  #@!method enrolled?(student_profile)
  # @param student_profile [StudentProfile] the student profile to check
  # @return [Boolean] true if the student is enrolled in the course, false otherwise
  # A method which checks if a student is enrolled in a course
  def enrolled?(student_profile)
    student_profiles.include?(student_profile)
  end

  #@!method enrolled_student(student_profile)
  # @param student_profile [StudentProfile] the student profile to enroll
  # @return [Boolean] false if the student is already enrolled in the course
  # @return [Boolean] false if the student is the author of the course
  # @return [Boolean] false if the student has already completed the course
  # @return [CourseEnrollment] the course enrollment for the student if successful
  # A method which enrolls a student in a course
  def enroll_student(student_profile)
    if student_profile.user.author_profile.course_ids.include?(id)
      errors.add(:base,"Student is the author of this course")
      return false
    elsif enrolled?(student_profile)
      errors.add(:base, "Student is already enrolled in this course")
      return false
    elsif completed_by_student?(student_profile)
      errors.add(:base,"Student has completed this course")
      return false
    else
      course_enrollments.create(student_profile: student_profile, status: "enrolled")
    end
  end

  #@!method currently_enrolled?(student_profile)
  # @param student_profile [StudentProfile] the student profile to check if enrolled
  # @return [Boolean] true if the student is currently enrolled in the course, false otherwise
  # A method which checks if a student is currently enrolled in a course
  def currently_enrolled?(student_profile)
    Course.active_courses_by_student(student_profile.id).map(&:id).include?(id)
  end

  # @!method completed_by_student?(student_profile)
  # @param student_profile [StudentProfile] the student profile to check if completed
  # @return [Boolean] true if the student has completed the course, false otherwise
  # A method which checks if a student has completed a course
  def completed_by_student?(student_profile)
    Course.completed_by_student(student_profile.id).map(&:id).include?(id)
  end

  # @!method complete_course(student_profile)
  # @param student_profile [StudentProfile] the student profile to complete the course
  # @return [Boolean] false if the student is not enrolled in the course
  # @return [Boolean] false if the student has already completed the course

  # A method which completes a course for a student
  def complete_course(student_profile)
    if currently_enrolled?(student_profile)
      course_enrollments.where(student_profile_id: student_profile.id, status: "enrolled").update(status: "completed")
      learning_paths.each do |learning_path|
        learning_path.next_course(student_profile, id)
      end
    elsif completed_by_student?(student_profile)
      errors.add(:base, "Student has already completed this course")
    elsif !enrolled?(student_profile)
      errors.add(:base, "Student is not enrolled in this course")
      return false
    end
  end

end
