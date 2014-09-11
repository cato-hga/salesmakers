class TextPost < ActiveRecord::Base
  include Publishable
  include PersonVisibility

  belongs_to :person
end
