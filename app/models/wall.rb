class Wall < ActiveRecord::Base
  belongs_to :wallable, polymorphic: true

end