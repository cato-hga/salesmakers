class PublicationModel < ActiveRecord::Base
  after_save :update_score
  after_save :create_publication

  belongs_to :wall
  belongs_to :publication
  belongs_to :person

  def update_score
    #TODO: Update_score
  end

  def create_wall_post(wall)
    person.reload
    WallPost.create wall: person.wall,
                    person: person,


    #TODO: create publication
  end

  protected

    def create_publication(person)
      Publication.find_or_create_by publishable: self
    end

end