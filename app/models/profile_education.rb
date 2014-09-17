class ProfileEducation < ActiveRecord::Base
  belongs_to :profile

  validates :school, presence: true
  validates :degree, presence: true
  validates :field_of_study, presence: true
  validates :start_year, numericality: { greater_than: 1900, less_than: 2100 }
  validates :start_year, numericality: { greater_than: 1900, less_than: 2100 }

  default_scope { order end_year: :desc, start_year: :desc }

end