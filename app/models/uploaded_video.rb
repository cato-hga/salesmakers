class UploadedVideo < ActiveRecord::Base
  include UploadableMedia
  include Publishable

  has_one :medium
  belongs_to :person
end
