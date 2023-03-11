class AuthorProfile < ApplicationRecord
  belongs_to :user
  has_many :courses

  validates :user_id, presence: true
end
