class CreateAuthorProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :author_profiles do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
