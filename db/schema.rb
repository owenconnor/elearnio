# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_03_10_230416) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "author_profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_author_profiles_on_user_id"
  end

  create_table "course_enrollments", force: :cascade do |t|
    t.bigint "student_profile_id", null: false
    t.bigint "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status"
    t.index ["course_id"], name: "index_course_enrollments_on_course_id"
    t.index ["student_profile_id"], name: "index_course_enrollments_on_student_profile_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "title"
    t.integer "author_profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "courses_learning_paths", id: false, force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "learning_path_id", null: false
    t.index ["course_id", "learning_path_id"], name: "index_courses_learning_paths_on_course_id_and_learning_path_id"
    t.index ["learning_path_id", "course_id"], name: "index_courses_learning_paths_on_learning_path_id_and_course_id"
  end

  create_table "learning_path_enrollments", force: :cascade do |t|
    t.bigint "student_profile_id", null: false
    t.bigint "learning_path_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status"
    t.index ["learning_path_id"], name: "index_learning_path_enrollments_on_learning_path_id"
    t.index ["student_profile_id"], name: "index_learning_path_enrollments_on_student_profile_id"
  end

  create_table "learning_paths", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "student_profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_student_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.integer "student_profile_id"
    t.integer "author_profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id", "author_profile_id", "student_profile_id"], name: "index_users_on_id_and_author_profile_id_and_student_profile_id"
  end

  add_foreign_key "author_profiles", "users"
  add_foreign_key "course_enrollments", "courses"
  add_foreign_key "course_enrollments", "student_profiles"
  add_foreign_key "learning_path_enrollments", "learning_paths"
  add_foreign_key "learning_path_enrollments", "student_profiles"
  add_foreign_key "student_profiles", "users"
end
