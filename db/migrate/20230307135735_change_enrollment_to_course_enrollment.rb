class ChangeEnrollmentToCourseEnrollment < ActiveRecord::Migration[6.1]
  def change
    rename_table :enrollments, :course_enrollments
  end
end
