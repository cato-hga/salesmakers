module UploadableMedia
  extend ActiveSupport::Concern

  included do
    after_save :create_medium
    has_one :medium
    scope :visible, -> (person = nil) {
      return self.none unless person
      visible_images = UploadedImage.visible(person)
      visible_videos = UploadedVideo.visible(person)
      media_for_images = self.where(medium_type: 'UploadedImage').where("medium_id IN (#{visible_images.map(&:id).join(',')})")
      media_for_videos = self.where(medium_type: 'UploadedVideo').where("medium_id IN (#{visible_videos.map(&:id).join(',')})")
      media_for_images.merge media_for_videos
      #TODO: Test this once we have media
    }
  end

  protected

    def create_medium
      return if self.medium
      Medium.create medium: self
    end
end


