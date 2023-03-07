class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.string :title
      t.integer :author_id

      t.timestamps
    end
  end
end
