class AddStatusToLearningPathEnrollment < ActiveRecord::Migration[6.1]
  def change
    add_column :learning_path_enrollments, :status, :string
  end
end
