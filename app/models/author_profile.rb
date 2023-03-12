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

  validates :user_id, presence: true
end
