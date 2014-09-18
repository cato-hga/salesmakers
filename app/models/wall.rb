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
          for area in person_area.area.ancestors do
            walls << area.wall if area.wall
          end
        end
      end
    end

    return Wall.none if walls.count < 1

    Wall.where("\"walls\".\"id\" IN (#{walls.map(&:id).join(',')})")
  }

  scope :postable, ->(person = nil) {
    walls = Array.new
    walls = walls.concat Wall.visible(person)
    position = person.position
    return Wall.none unless position

    unless position.hq?
      for person_area in person.person_areas do
        for area in person_area.area.ancestors do
          walls.delete area.wall if area.wall
        end
      end
    end
    self.where("\"walls\".\"id\" IN (#{walls.map(&:id).join(',')})").where.not(wallable: person)
  }

  def self.fetch_wall(wallable)
    return unless wallable
    self.find_or_create_by wallable: wallable
  end

  def name
    return nil unless self.wallable
    if defined?(self.wallable.project) and self.wallable.project
      self.wallable.project.name + ' - ' + self.wallable.name
    else
      self.wallable.name if self.wallable
    end
  end
end