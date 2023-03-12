require 'faker'
require 'factory_bot_rails'

FactoryBot.create_list(:learning_path, 10, :with_courses)

50.times do
  LearningPath.all.sample.subscribe_student(FactoryBot.create(:user).student_profile)
end





