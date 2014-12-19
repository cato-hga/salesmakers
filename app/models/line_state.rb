class LineState < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 3 }, uniqueness: { case_sensitive: false }

  has_and_belongs_to_many :lines

  default_scope { order :name }
end
