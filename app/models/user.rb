class User < ApplicationRecord
  has_one :author_profile
  has_one :student_profile
end
