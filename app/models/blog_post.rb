class BlogPost < ActiveRecord::Base
  include Publishable
  include PersonVisibility

  belongs_to :person

  default_scope { order( created_at: :desc) }
end
