# == Schema Information
#
# Table name: report_queries
#
#  id                 :integer          not null, primary key
#  name               :string           not null
#  category_name      :string           not null
#  database_name      :string           not null
#  query              :text             not null
#  permission_key     :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  has_date_range     :boolean          default(FALSE), not null
#  start_date_default :string
#

class ReportQuery < ActiveRecord::Base
  validates :name, presence: true
  validates :category_name, presence: true
  validates :database_name, presence: true
  validates :query, presence: true
  validates :permission_key, presence: true
  validates :start_date_default, presence: true, if: :has_date_range?

  has_many :log_entries, as: :trackable, dependent: :destroy


  strip_attributes

  default_scope { order :category_name, :name }
end
