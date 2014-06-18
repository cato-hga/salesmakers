class Person < ActiveRecord::Base
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }
  validates :display_name, presence: true, length: { minimum: 5 }
  validates :email, presence: true, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/ } #TODO Prompt for valid email
  validates :personal_email, presence: true, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/ } #TODO Prompt for valid email
  validates :position, presence: true


  belongs_to :position
#TODO Why the hell does this need to be belongs_to instead of has_one?
end
