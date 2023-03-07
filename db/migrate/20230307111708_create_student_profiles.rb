class CreateStudentProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :student_profiles do |t|
      t.references :user, index: true, foreign_key: true
      t.timestamps
    end
  end
end
