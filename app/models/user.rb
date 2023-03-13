# A model for a user of the application. A user can be a student or an author.
class User < ApplicationRecord
  #@!attribute email
  # @return [String] The email address of the user.
  # @!attribute first_name
  # @return [String] The first name of the user.
  # @!attribute last_name
  # @return [String] The last name of the user.
  # @!attribute created_at
  # @return [DateTime] The date and time the user was created.
  # @!attribute updated_at
  # @return [DateTime] The date and time the user was last updated.
  # @!attribute id
  # @return [Integer] The ID of the user.
  # @!attribute author_profile
  # @return [AuthorProfile] The author profile of the user if they are an author.
  # @!attribute student_profile
  # @return [StudentProfile] The student profile of the user if they are a student.
  # @!attribute author_profile_id
  # @return [Integer] The ID of the author profile of the user if they are an author.
  # @!attribute student_profile_id
  # @return [Integer] The ID of the student profile of the user if they are a student.

  has_one :author_profile, dependent: :destroy
  has_one :student_profile, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  after_create :create_student_profile
  after_create :create_author_profile

  scope :subscribed_learning_paths, -> (user) { user.student_profile.learning_path_enrollments.where(status: "subscribed").map(&:learning_path) }
  scope :completed_learning_paths, -> (user) { user.student_profile.learning_path_enrollments.where(status: "completed").map(&:learning_path) }
end
