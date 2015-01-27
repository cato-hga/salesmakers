# module Publishable
#   extend ActiveSupport::Concern
#
#   included do
#     after_save :update_score
#     after_save :create_publication
#
#     has_one :publication, as: :publishable
#     has_many :wall_posts, through: :publications
#   end
#
#   def update_score
#   end
#
#   def create_wall_post(wall, person)
#     WallPost.create wall: wall,
#                     person: person,
#                     publication: self.publication
#   end
#
#   protected
#
#     def create_publication
#       Publication.find_or_create_by publishable: self
#     end
#
# end