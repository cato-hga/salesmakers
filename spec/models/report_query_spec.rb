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

require 'rails_helper'

describe ReportQuery do
  subject { build :report_query }

  it 'responds to has_date_range? and has_date_range=' do
    expect(subject).to respond_to :has_date_range?
    expect(subject).to respond_to :has_date_range=
  end

  it 'responds to start_date_default and start_date_default=' do
    expect(subject).to respond_to :start_date_default
    expect(subject).to respond_to :start_date_default=
  end
end
