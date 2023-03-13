require 'rails_helper'

RSpec.describe AuthorProfile, type: :model do
  describe 'methods' do
    describe '#transfer_courses' do
      let(:author) { create(:user) }
      let(:course) { create(:course, author_profile: author.author_profile) }
      let(:new_author_profile) { create(:user) }

      it 'transfers courses to another author profile' do
        # new_author_profile = new_author_profiles.first
        expect { author.author_profile.destroy }.to change { course.reload.author_profile_id }.from(author.author_profile.id).to(new_author_profile.author_profile_id)
      end
    end
  end

end
