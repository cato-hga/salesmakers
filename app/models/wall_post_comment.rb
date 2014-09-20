class WallPostComment < ActiveRecord::Base
  validates :wall_post, presence: true
  validates :person, presence: true
  validates :comment, length: { minimum: 1 }

  belongs_to :wall_post
  belongs_to :person
end
