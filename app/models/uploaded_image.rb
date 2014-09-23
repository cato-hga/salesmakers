class UploadedImage < ActiveRecord::Base
  dragonfly_accessor :image do
    copy_to(:thumbnail) { |a| a.thumb('200x200#') }
    copy_to(:preview) { |a| a.thumb('500x') }
    copy_to(:large) { |a| a.thumb('750x') }
  end
  dragonfly_accessor :thumbnail
  dragonfly_accessor :preview
  dragonfly_accessor :large

  include UploadableMedia
  include Publishable
  include PersonVisibility

  belongs_to :person

end
