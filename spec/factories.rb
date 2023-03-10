FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }

    trait :with_student_profile do
      after(:create) do |user|
        user.create_student_profile
      end
    end

    trait :with_author_profile do
      after(:create) do |user|
        user.create_author_profile
      end
    end

    trait :with_student_and_author_profiles do
      after(:create) do |user|
        user.create_student_profile
        user.create_author_profile
      end
    end
  end

  factory :course do
    title { Faker::Educator.course_name }
    author_profile_id { FactoryBot.create(:user, :with_author_profile).author_profile.id }

    trait :with_students do
      after(:create) do |course|
        course.student_profiles << FactoryBot.create_list(:user, 5, :with_student_profile).map(&:student_profile)
      end

    trait :with_learning_paths do
      after(:create) do |course|
        course.learning_paths << FactoryBot.create_list(:learning_path, 5).map(&:learning_path)
      end
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
        learning_path.student_profiles << FactoryBot.create_list(:user, 5, :with_student_profile).map(&:student_profile)
      end
    end
  end
end
