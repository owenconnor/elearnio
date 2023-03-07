class RenameAuthorIdInCourses < ActiveRecord::Migration[6.1]
  def change
    rename_column :courses, :author_id, :author_profile_id
  end
end
