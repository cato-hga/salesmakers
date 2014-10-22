require 'rails_helper'

RSpec.describe WallPostComment, :type => :model do

  describe 'is_edited method' do
    let(:wall_post_comment) { build_stubbed :wall_post_comment, created_at: Time.now, updated_at: Time.now + 2.minutes }

    it 'should return true if the created and updated times differ' do
      expect(wall_post_comment.is_edited?).to be_truthy
    end
  end
end