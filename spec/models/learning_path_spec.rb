require 'rails_helper'

RSpec.describe LearningPath, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      learning_path = build(:learning_path)
      expect(learning_path).to be_valid
    end

    it "is not valid without a title" do
      learning_path = build(:learning_path, title: nil)
      expect(learning_path).to_not be_valid
    end
  end

  describe "associations" do
    it "has many learning path enrollments" do
      learning_path = create(:learning_path)
      expect(learning_path).to respond_to(:learning_path_enrollments)
    end

    it "has many student profiles through learning path enrollments" do
      learning_path = create(:learning_path)
      expect(learning_path).to respond_to(:student_profiles)
    end

    it "has and belongs to many courses" do
      learning_path = create(:learning_path)
      expect(learning_path).to respond_to(:courses)
    end
  end

  describe "methods" do
    before(:each) do
      @learning_path = create(:learning_path, :with_courses)
      @user = create(:user)
    end
    describe '#subscribe_student' do
      it 'subscribes a student to the learning path' do
        @learning_path.subscribe_student(@user.student_profile)
        expect(@learning_path.subscribed_students).to include(@user.student_profile)
      end

      it 'enrolls the student in the first course of the learning path' do
        @learning_path.subscribe_student(@user.student_profile)
        expect(@learning_path.courses.order(:created_at).first.student_profiles).to include(@user.student_profile)
      end

      it 'returns false if the student is already subscribed to the learning path' do
        @learning_path.subscribe_student(@user.student_profile)
        expect(@learning_path.subscribe_student(@user.student_profile)).to eq(false)
      end
    end

    describe '#next_course' do
      it 'enrolls the student in the next course of the learning path' do
        @learning_path.subscribe_student(@user.student_profile)
        @learning_path.next_course(@user.student_profile, @learning_path.courses.order(:created_at).first.id)
        expect(@learning_path.courses.order(:created_at).second.student_profiles).to include(@user.student_profile)
      end

      it 'returns false if the student is not subscribed to the learning path' do
        expect(@learning_path.next_course(@user.student_profile, @learning_path.courses.order(:created_at).first.id)).to eq(false)
      end

      it 'returns "Learning path completed" if the student has completed the learning path' do
        @learning_path.subscribe_student(@user.student_profile)
        @learning_path.courses.order(:created_at).each do |course|
          @learning_path.next_course(@user.student_profile, course.id)
        end
        expect(@learning_path.next_course(@user.student_profile, @learning_path.courses.order(:created_at).last.id)).to eq("Learning path completed")
      end

    end
  end

end
