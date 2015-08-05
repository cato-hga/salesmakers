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

class GroupMePost < ActiveRecord::Base
  before_save :set_person

  belongs_to :group_me_user
  belongs_to :group_me_group
  # has_many :group_me_likes
  belongs_to :person

  private

  def set_person
    return unless self.group_me_user
    self.person = self.group_me_user.person
  end
end
