class Wall < ActiveRecord::Base
  belongs_to :wallable, polymorphic: true
  has_many :wall_posts

  scope :visible, ->(person = nil) {
    return Wall.none unless person
    walls = Array.new
    walls << person.wall if person.wall
    position = person.position

    return walls unless position

    if WallPolicy.new(person, Wall.new).show_all_walls?
      walls = walls.concat Wall.where("wallable_type != 'Person'")
    else
      if position.hq?
        walls << position.department.wall if position.department.wall
        walls = walls.concat Wall.where("wallable_type = 'Area'")
      else
        for person_area in person.person_areas do
          areas = person_area.area.subtree
          for area in areas do
            walls << area.wall if area.wall
          end
        end
      end
    end

    return Wall.none if walls.count < 1

    Wall.where("\"walls\".\"id\" IN (#{walls.map(&:id).join(',')})")
  }

  def self.fetch_wall(wallable)
    return unless wallable
    self.find_or_create_by wallable: wallable
  end
end