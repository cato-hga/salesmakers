class ReportQuery < ActiveRecord::Base
  validates :name, presence: true
  validates :category_name, presence: true
  validates :database_name, presence: true
  validates :query, presence: true
  validates :permission_key, presence: true
  validates :start_date_default, presence: true, if: :has_date_range?

  nilify_blanks

  default_scope { order :category_name, :name }
end
