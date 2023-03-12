require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user = build(:user, email: nil)
      expect(user).to_not be_valid
    end

    it 'is not valid without a first name' do
      user = build(:user, first_name: nil)
      expect(user).to_not be_valid
    end

    it 'is not valid without a last name' do
      user = build(:user, last_name: nil)
      expect(user).to_not be_valid
    end

    it 'is not valid with a duplicate email' do
      user = create(:user)
      user2 = build(:user, email: user.email)
      expect(user2).to_not be_valid
    end
  end

  describe 'associations' do
    it 'has one student profile' do
      user = create(:user)
      expect(user).to respond_to(:student_profile)
    end

    it 'has one author profile' do
      user = create(:user)
      expect(user).to respond_to(:author_profile)
    end
  end

  describe 'scopes' do
    before(:each) do
      @user = create(:user)
    end

    describe '#subscribed_learning_paths' do
      it 'returns an array of learning paths that the user is subscribed to' do
        learning_path = create(:learning_path, :with_courses)
        learning_path.subscribe_student(@user.student_profile)
        expect(User.subscribed_learning_paths(@user)).to include(learning_path)
      end
    end

    describe '#completed_learning_paths' do
      it 'returns an array of learning paths that the user has completed' do
        learning_path = create(:learning_path, :with_courses)
        learning_path.subscribe_student(@user.student_profile)
        learning_path.courses.each do |course|
          course.complete_course(@user.student_profile)
        end
        expect(User.completed_learning_paths(@user)).to include(learning_path)
      end
    end
  end



end
