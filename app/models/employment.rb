class Employment < ActiveRecord::Base
  belongs_to :person

  validates :start, presence: true

  default_scope { order start: :desc }
end
