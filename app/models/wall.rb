class Wall < ActiveRecord::Base
  belongs_to :wallable, polymorphic: true
  has_many :wall_posts

  def self.fetch_wall(wallable)
    return unless wallable
    self.find_or_create_by wallable: wallable
  end
end