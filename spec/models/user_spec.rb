require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_one(:author_profile) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end

  describe 'instance methods' do

  end

  describe 'class methods' do

  end

  describe 'callbacks' do

  end

  describe 'scopes' do

  end

  describe 'custom validations' do

  end
end
