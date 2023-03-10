class Course < ApplicationRecord
  belongs_to :author_profile
  has_many :course_enrollments
  has_many :student_profiles, through: :course_enrollments
  has_and_belongs_to_many :learning_paths

  validates :title, presence: true
  validates :author_profile_id, numericality: { only_integer: true }, presence: true
  validates :course_enrollments, uniqueness: { scope: :student_profile_id }


  scope :by_author, -> (author_profile_id) { where(author_profile_id: author_profile_id) }
  scope :by_student, -> (student_profile_id) { joins(:course_enrollments).where(course_enrollments: { student_profile_id: student_profile_id }) }
  scope :by_learning_path, -> (learning_path_id) { joins(:learning_paths).where(learning_paths: { id: learning_path_id }) }
  scope :with_students, -> { joins(:student_profiles) }
  scope :with_learning_paths, -> { joins(:learning_paths) }

  def enrolled_students
    student_profiles
  end

  def enrolled?(student_profile)
    student_profiles.include?(student_profile)
  end

  def enroll_student(student_profile)
    if student_profile.user.author_profile.course_ids.include?(id)
      #TODO: add spec for this
      errors.add(:base, "Author cannot enroll in their own course")
      return false
    elsif enrolled?(student_profile)
      #TODO: add spec for this
      errors.add(:base, "Student is already enrolled in this course")
      return false
    else
      course_enrollments.create(student_profile: student_profile)
    end
  end

  def complete_course(student_profile)
    if student_profile.user.author_profile.course_ids.include?(id)
      course_enrollments.where(student_profile: student_profile).first.update(completed: true)
      #TODO: here we need to call a method that will move the student to the next course in the learning path
    elsif !enrolled?(student_profile)
      #TODO: add spec for this
      errors.add(:base, "Student is not enrolled in this course")
      return false
    end
  end

end
