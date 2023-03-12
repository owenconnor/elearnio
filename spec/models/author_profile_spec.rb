require 'rails_helper'

RSpec.describe AuthorProfile, type: :model do
  describe 'methods' do
    describe '#transfer_courses' do
      let(:author) { create(:user) }
      let(:course) { create(:course, author_profile: author.author_profile) }
      let(:new_author) { create(:user) }

      it 'transfers courses to another author profile' do
        expect { author.author_profile.destroy }.to change { course.reload.author_profile }.from(author.author_profile).to(new_author.author_profile)
      end
    end
  end

end
