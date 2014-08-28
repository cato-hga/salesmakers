class UploadedVideo < ActiveRecord::Base
  include Publishable

  has_one :medium
  belongs_to :person
end
