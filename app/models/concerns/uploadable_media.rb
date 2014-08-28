module UploadableMedia
  extend ActiveSupport::Concern

  included do
    after_save :create_medium
    has_one :medium
  end

  protected

    def create_medium
      return if self.medium
      Medium.create medium: self
    end
end


