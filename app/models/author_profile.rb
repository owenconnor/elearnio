# Represents an author profile for a user
class AuthorProfile < ApplicationRecord
  # @!attribute [r] id
  #  @return [Integer] the unique identifier for the author profile
  # @!attribute [rw] user_id
  # @!attribute [rw] courses
  # @return [Array<Course>] the courses authored by the user
  # @!attribute [rw] user
  # @return [User] the user associated with the author profile

  belongs_to :user
  has_many :courses

  before_destroy :transfer_courses

  validates :user_id, presence: true
  validates :user_id, uniqueness: true

  def transfer_courses
    courses.update_all(author_profile_id: AuthorProfile.all.sample.id)
  end

end
