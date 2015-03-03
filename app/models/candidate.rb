class Candidate < ActiveRecord::Base

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :mobile_phone, presence: true, uniqueness: true
  validates :email, presence: true
  validates :zip, presence: true
  validates :project_id, presence: true

  belongs_to :project
end
