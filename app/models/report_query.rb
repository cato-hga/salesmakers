class ReportQuery < ActiveRecord::Base
  validates :name, presence: true
  validates :category_name, presence: true
  validates :database_name, presence: true
  validates :query, presence: true
  validates :permission_key, presence: true

  default_scope { order :category_name, :name }
end
