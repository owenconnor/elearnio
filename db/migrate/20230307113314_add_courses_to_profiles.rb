class AddCoursesToProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :student_profiles, :courses, :string, array: true, default: []
  end
end
