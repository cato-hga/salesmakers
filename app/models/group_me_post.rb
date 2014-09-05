class GroupMePost < ActiveRecord::Base
  before_save :set_person

  belongs_to :group_me_user
  belongs_to :group_me_group
  has_many :group_me_likes
  belongs_to :person

  private

  def set_person
    return unless self.group_me_user
    self.person = self.group_me_user.person
  end
end
