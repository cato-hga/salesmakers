class Employment < ActiveRecord::Base
  belongs_to :person

  validates :start, presence: true
end
