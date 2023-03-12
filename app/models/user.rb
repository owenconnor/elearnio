class User < ApplicationRecord
  has_one :author_profile
  has_one :student_profile

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  after_create :create_student_profile
  after_create :create_author_profile

  scope :subscribed_learning_paths, -> (user) { user.student_profile.learning_path_enrollments.where(status: "subscribed").map(&:learning_path) }
  scope :completed_learning_paths, -> (user) { user.student_profile.learning_path_enrollments.where(status: "completed").map(&:learning_path) }
end
