# class Wall < ActiveRecord::Base
#   belongs_to :wallable, polymorphic: true
#   has_many :wall_posts
#
#   scope :visible, ->(person = nil) {
#     return Wall.none unless person
#     walls = Array.new
#     walls << person.wall if person.wall
#     position = person.position
#
#     return walls unless position
#
#     if WallPolicy.new(person, Wall.new).show_all_walls?
#       walls = walls.concat Wall.where("wallable_type != 'Person'")
#     else
#       walls << person.position.department.wall if person.position.department.wall
#       if position.hq?
#         walls << position.department.wall if position.department.wall
#         walls = walls.concat Wall.where("wallable_type = 'Area'")
#         walls = walls.concat Wall.where("wallable_type = 'Project'")
#       else
#         for person_area in person.person_areas do
#           areas = person_area.area.subtree
#           for area in areas do
#             walls << area.wall if area.wall
#             walls << area.project.wall unless not area.project.wall or walls.include? area.project
#           end
#           for area in person_area.area.ancestors do
#             walls << area.wall if area.wall
#           end
#         end
#       end
#     end
#
#     return Wall.none if walls.count < 1
#
#     Wall.where("\"walls\".\"id\" IN (#{walls.map(&:id).join(',')})")
#   }
#
#   scope :postable, ->(person = nil) {
#     visible_walls = Array.new
#     walls = Array.new
#     visible_walls = visible_walls.concat Wall.visible(person)
#     position = person.position
#     return Wall.none unless position
#
#     unless position.hq?
#       for person_area in person.person_areas do
#         for area in person_area.area.ancestors do
#           visible_walls.delete area.wall if area.wall
#         end
#       end
#       for wall in visible_walls do
#         unless wall.wallable.is_a? Department or wall.wallable.is_a? Project
#           walls << wall
#         end
#       end
#     else
#       walls = visible_walls
#     end
#     walls.delete person.wall if person.wall
#     return Wall.none if walls.count < 1
#     Wall.where("\"walls\".\"id\" IN (#{walls.map(&:id).join(',')})")
#   }
#
#   def self.fetch_wall(wallable)
#     return unless wallable
#     self.find_or_create_by wallable: wallable
#   end
#
#   def name
#     return '' unless self.wallable and self.wallable.name
#     if defined?(self.wallable.project) and self.wallable.project
#       self.wallable.project.name + ' - ' + self.wallable.name
#     elsif self.wallable.is_a? Project
#       'RBD Project - ' + self.wallable.name
#     elsif self.wallable.is_a? Department
#       'RBD Department - ' + self.wallable.name
#     else
#       self.wallable.name if self.wallable
#     end
#   end
# end