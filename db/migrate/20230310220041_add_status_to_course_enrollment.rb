class AddStatusToCourseEnrollment < ActiveRecord::Migration[6.1]
  def change
    add_column :course_enrollments, :status, :string
  end
end
