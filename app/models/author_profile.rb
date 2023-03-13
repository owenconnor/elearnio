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
  validates :user_id, uniqueness: true, on: [:create, :update]

  def transfer_courses
    new_author_profile = AuthorProfile.all.sample
    Rails.logger.info "Transferring courses from #{self.id} to #{new_author_profile.id}"
    courses.update_all(author_profile_id: new_author_profile)
  end

end
