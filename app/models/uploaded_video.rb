class UploadedVideo < ActiveRecord::Base
  include UploadableMedia
  include Publishable
  include PersonVisibility

  has_one :medium
  belongs_to :person
end
