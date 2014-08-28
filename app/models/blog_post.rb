class BlogPost < ActiveRecord::Base
  include Publishable

  belongs_to :person
end
