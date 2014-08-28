class PublicationModel < ActiveRecord::Base
  after_save :update_score
  after_save :create_wall_post
  after_save :create_publication

  def update_score
    #TODO: Update_score
  end

  protected

    def create_wall_post
      #TODO: Create wall post
    end

    def create_publication
      #TODO: create publication
    end

end