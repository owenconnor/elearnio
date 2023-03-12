require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'methods' do
    describe '#enroll_student' do
      let(:student) { create(:user) }
      let(:course) { create(:course) }

      it 'should create a CourseEnrollment' do
        expect { course.enroll_student(student.student_profile) }.to change { CourseEnrollment.count }.by(1)
      end

      it 'should not create a CourseEnrollment if the student is the author' do
        course.update(author_profile_id: student.author_profile.id)
        expect { course.enroll_student(student.student_profile) }.to change { CourseEnrollment.count }.by(0)
      end

      it 'should not create a CourseEnrollment if the student is already enrolled' do
        course.enroll_student(student.student_profile)
        expect { course.enroll_student(student.student_profile) }.to change { CourseEnrollment.count }.by(0)
      end

      it 'should not create a CourseEnrollment if the student has already completed the course' do
        course.enroll_student(student.student_profile)
        course.complete_course(student.student_profile)
        expect { course.enroll_student(student.student_profile) }.to change { CourseEnrollment.count }.by(0)
      end
    end

    describe '#currently_enrolled?' do
      let(:student) { create(:user) }
      let(:course) { create(:course) }

      it 'should return true if the student is currently enrolled' do
        course.enroll_student(student.student_profile)
        expect(course.currently_enrolled?(student.student_profile)).to be true
      end

      it 'should return false if the student is not currently enrolled' do
        expect(course.currently_enrolled?(student.student_profile)).to be false
      end

      it 'should return false if the student has completed the course' do
        course.enroll_student(student.student_profile)
        course.complete_course(student.student_profile)
        expect(course.currently_enrolled?(student.student_profile)).to be false
      end

      it 'should return false if the student is not enrolled' do
        expect(course.currently_enrolled?(student.student_profile)).to be false
      end
    end

    describe '#completed_by_student?' do
      let(:student) { create(:user) }
      let(:course) { create(:course) }

      it 'should return true if the student has completed the course' do
        course.enroll_student(student.student_profile)
        course.complete_course(student.student_profile)
        expect(course.completed_by_student?(student.student_profile)).to be true
      end

      it 'should return false if the student has not completed the course' do
        course.enroll_student(student.student_profile)
        expect(course.completed_by_student?(student.student_profile)).to be false
      end

      it 'should return false if the student is not enrolled' do
        expect(course.completed_by_student?(student.student_profile)).to be false
      end
    end

    describe '#complete_course' do
      let(:student) { create(:user) }
      let(:course) { create(:course) }

      it 'should add increment completed courses count' do
        course.enroll_student(student.student_profile)
        expect { course.complete_course(student.student_profile) }.to change { Course.completed_by_student(student.student_profile.id).count }.by(1)
      end

      it 'should not increment completed courses count if the student is not enrolled' do
        expect { course.complete_course(student.student_profile) }.to change { Course.completed_by_student(student.student_profile.id).count }.by(0)
      end

      it 'should not increment completed courses count if the student has already completed the course' do
        course.enroll_student(student.student_profile)
        course.complete_course(student.student_profile)
        expect { course.complete_course(student.student_profile) }.to change { Course.completed_by_student(student.student_profile.id).count }.by(0)
      end
    end
  end
end

