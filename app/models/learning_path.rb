# Represents a learning path that a student can subscribe to
class LearningPath < ApplicationRecord
  #@!attribute title
  # @return [String] The title of the learning path.
  # @!attribute id
  # @return [Integer] The ID of the learning path.
  # @!attribute courses
  # @return [Array<Course>] The courses in the learning path.
  # @!attribute learning_path_enrollments
  # @return [Array<LearningPathEnrollment>] The enrollments in the learning path.
  # @!attribute student_profiles
  # @return [Array<StudentProfile>] The student profiles of the students subscribed to the learning path.
  has_many :learning_path_enrollments
  has_many :student_profiles, through: :learning_path_enrollments
  has_and_belongs_to_many :courses

  validates :title, presence: true

  #@!method next_course(student_profile, completed_course_id)
  # @param student_profile [StudentProfile] The student profile of the student who completed the course.
  # @param completed_course_id [Integer] The ID of the course that was completed.
  # @return [Course, String] The next course in the learning path, or a string indicating that the learning path is completed.
  def next_course(student_profile, completed_course_id)
    completed_course = Course.find(completed_course_id)
    if subscribed?(student_profile)
      if completed_course.id == courses.order(:created_at).last.id
        learning_path_enrollments.where(student_profile: student_profile).first.update(status: "completed")
      else
        next_course = courses.where('created_at > ?', completed_course.created_at).order('created_at ASC').first
        if next_course
          next_course.enroll_student(student_profile)
        else
          return "Learning path completed"
        end
      end
    else
      errors.add(:base, "Student is not subscribed to this learning path")
      return false
    end
  end

  def subscribed_students
    student_profiles
  end

  def subscribed?(student_profile)
    student_profiles.include?(student_profile)
  end

  #@!method subscribe_student(student_profile)
  # @param student_profile [StudentProfile] The student profile of the student who is subscribing to the learning path.
  # @return [Boolean] True if the student was successfully subscribed to the learning path, false otherwise. TODO: This should return a LearningPathEnrollment object.
  def subscribe_student(student_profile)
    if subscribed?(student_profile)
      errors.add(:base, "Student is already subscribed to this learning path")
      return false
    else
      learning_path_enrollments.create(student_profile: student_profile, status: "subscribed")
      courses.order(:created_at).first.enroll_student(student_profile)
    end
  end

  #@!method unsubscribe_student(student_profile)
  # @param student_profile [StudentProfile] The student profile of the student who is unsubscribing from the learning path.
  # @return [Boolean] True if the student was successfully unsubscribed from the learning path, false otherwise. TODO: This should return a LearningPathEnrollment object.
  def unsubscribe_student(student_profile)
    if subscribed?(student_profile)
      learning_path_enrollments.where(student_profile: student_profile).first.destroy
    else
      errors.add(:base, "Student is not subscribed to this learning path")
      return false
    end
  end

  #@!method complete_learning_path(student_profile)
  # @param student_profile [StudentProfile] The student profile of the student who is completing the learning path.
  # @return [Boolean] True if the student was successfully completed the learning path, false otherwise. TODO: This should return a LearningPathEnrollment object.
  # @note This method should be called when a student completes the last course in the learning path.
  def complete_learning_path(student_profile)
    if subscribed?(student_profile)
      learning_path_enrollments.where(student_profile: student_profile).first.update(status: "completed")
    else
      errors.add(:base, "Student is not subscribed to this learning path")
      return false
    end
  end

end
