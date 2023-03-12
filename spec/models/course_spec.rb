require 'rails_helper'

RSpec.describe Course, type: :model do
  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:author_profile) }
  end

  context 'associations' do
    it { should belong_to(:author_profile) }
    it { should have_many(:course_enrollments) }
    it { should have_many(:student_profiles).through(:course_enrollments) }
    it { should have_and_belong_to_many(:learning_paths) }
  end

  context 'methods' do
    describe '#enrolled?' do
      let(:course) { create(:course) }
      let(:student_profile) { create(:student_profile) }

      context 'when the student is enrolled' do
        before { create(:course_enrollment, course: course, student_profile: student_profile) }

        it 'returns true' do
          expect(course.enrolled?(student_profile)).to eq true
        end
      end

      context 'when the student is not enrolled' do
        it 'returns false' do
          expect(course.enrolled?(student_profile)).to eq false
        end
      end
    end
  end
end

