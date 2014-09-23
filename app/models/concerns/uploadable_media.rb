module UploadableMedia
  extend ActiveSupport::Concern

  included do
    after_save :create_medium

    has_one :medium, as: :mediable

    # scope :visible, -> (person = nil) {
    #   return self.none unless person
    #   visible_images = UploadedImage.visible(person)
    #   visible_videos = UploadedVideo.visible(person)
    #   media_for_images = self.where(mediable_type: 'UploadedImage').where("mediable_id IN (#{visible_images.map(&:id).join(',')})")
    #   media_for_videos = self.where(mediable_type: 'UploadedVideo').where("mediable_id IN (#{visible_videos.map(&:id).join(',')})")
    #   media_for_images.merge media_for_videos
    # }
  end

  private

    def create_medium
      Medium.find_or_create_by mediable: self
    end
end


