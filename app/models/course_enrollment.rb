class CourseEnrollment < ApplicationRecord
  belongs_to :course
  belongs_to :student_profile
end

