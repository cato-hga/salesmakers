class Publication < ActiveRecord::Base
  belongs_to :publishable, polymorphic: true
end
