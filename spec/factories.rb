FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
  end

  factory :course do
    title { Faker::Educator.course_name }
    author_profile_id { FactoryBot.create(:user).author_profile.id }

    trait :with_students do
      after(:create) do |course|
        5.times do
          course.course_enrollments.create(student_profile_id: FactoryBot.create(:user).student_profile.id, status: "enrolled")
        end
      end
    end

    trait :with_learning_path do
      after(:create) do |course|
        course.learning_paths << FactoryBot.create_list(:learning_path, 5)
      end
    end
  end

  factory :learning_path do
    title { Faker::Lorem.word }

    trait :with_courses do
      after(:create) do |learning_path|
        learning_path.courses << FactoryBot.create_list(:course, 5)
      end
    end
    trait :with_students do
      after(:create) do |learning_path|
        learning_path.learning_path_enrollment.create(student_profile_id: FactoryBot.create(:user).student_profile.id, status: "subscribed")
      end
    end
  end
end
