class WallPost < ActiveRecord::Base

  belongs_to :wall
  belongs_to :person
  belongs_to :publication

  default_scope { order created_at: :desc}

  def self.create_from_publication(publication, wall)
    return unless publication and publication.publishable.person and publication.publishable.person and wall
    self.find_or_create_by publication: publication,
                           wall: wall,
                           person: publication.publishable.person
  end

  def self.visible(person)
    self.where wall: Wall.visible(person)
  end
end
