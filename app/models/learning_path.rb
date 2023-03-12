class LearningPath < ApplicationRecord
  has_many :learning_path_enrollments
  has_many :student_profiles, through: :learning_path_enrollments
  has_and_belongs_to_many :courses

  validates :title, presence: true

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

  def subscribe_student(student_profile)
    if subscribed?(student_profile)
      errors.add(:base, "Student is already subscribed to this learning path")
      return false
    else
      learning_path_enrollments.create(student_profile: student_profile, status: "subscribed")
      courses.order(:created_at).first.enroll_student(student_profile)
    end
  end

  def unsubscribe_student(student_profile)
    if subscribed?(student_profile)
      learning_path_enrollments.where(student_profile: student_profile).first.destroy
    else
      errors.add(:base, "Student is not subscribed to this learning path")
      return false
    end
  end

  def complete_learning_path(student_profile)
    if subscribed?(student_profile)
      learning_path_enrollments.where(student_profile: student_profile).first.update(status: "completed")
    else
      errors.add(:base, "Student is not subscribed to this learning path")
      return false
    end
  end

end
