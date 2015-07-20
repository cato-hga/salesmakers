class PersonPunch < ActiveRecord::Base
  validates :identifier, presence: true
  validates :punch_time, presence: true
  validates :in_or_out, presence: true

  belongs_to :person

  enum in_or_out: [:in, :out]

  nilify_blanks
end
