class UploadedImage < ActiveRecord::Base
  has_one :medium
  belongs_to :person
end
