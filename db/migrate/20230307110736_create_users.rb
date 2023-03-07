class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :student_profile_id
      t.integer :author_profile_id

      t.timestamps
    end
    add_index :users, [:id, :author_profile_id, :student_profile_id]
  end
end
