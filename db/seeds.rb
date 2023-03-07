require 'faker'

# Create some students
50.times do
  user = User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
  )
  user.create_student_profile
end

# Create some authors
10.times do
  user = User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
  )
  user.create_author_profile
end

#Create Author/Student Profiles
# 10.times do
#   User.create(
#     first_name: Faker::Name.first_name,
#     last_name: Faker::Name.last_name,
#     email: Faker::Internet.email,,
#     author_profile_id: AuthorProfile.create.id
#   )
# end

10.times do
  LearningPath.create(title: Faker::Educator.course_name)
end

50.times do
  course = Course.create(
    title: Faker::Educator.course_name,
    author_profile_id: AuthorProfile.all.sample.id
  )
  course.learning_paths << LearningPath.all.sample(rand(1..3))
end

# Create some enrollments
250.times do
  CourseEnrollment.create(
    student_profile_id: StudentProfile.all.sample.id,
    course_id: Course.all.sample.id
  )
end

50.times do
  LearningPathEnrollment.create(
    student_profile_id: StudentProfile.all.sample.id,
    learning_path_id: LearningPath.all.sample.id
  )
end





