class User < ApplicationRecord
  has_one :author_profile
  has_one :student_profile

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
end
