class Medium < ActiveRecord::Base
  belongs_to :medium, polymorphic: true
end
