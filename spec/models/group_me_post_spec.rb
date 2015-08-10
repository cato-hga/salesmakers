# == Schema Information
#
# Table name: group_me_posts
#
#  id                :integer          not null, primary key
#  group_me_group_id :integer          not null
#  posted_at         :datetime         not null
#  json              :text             not null
#  created_at        :datetime
#  updated_at        :datetime
#  group_me_user_id  :integer          not null
#  message_num       :string           not null
#  like_count        :integer          default(0), not null
#  person_id         :integer
#

# require 'rails_helper'
# require 'shoulda/matchers'
#
# RSpec.describe GroupMePost, :type => :model do
#
#   it { should belong_to(:group_me_user) }
#   it { should belong_to(:group_me_group) }
#   it { should have_many(:group_me_likes) }
#   it { should belong_to(:person) }
#
#   describe 'set_person callback' do
#     let(:person) { create :person }
#     let(:group_me_user) { create :group_me_user, person: person }
#     let(:group_me_post) { create :group_me_post, group_me_user: group_me_user }
#
#     it 'should set the person to a group_me_user' do
#       expect(group_me_post.person).to be(person)
#     end
#   end
# end
