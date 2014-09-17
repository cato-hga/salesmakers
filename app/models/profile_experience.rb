class ProfileExperience < ActiveRecord::Base
  belongs_to :profile

  validates :company_name, presence: true
  validates :title, presence: true
  validates :location, presence: true
  validates :started, presence: true
  validates :ended, presence: true, unless: :currently_employed?
end
