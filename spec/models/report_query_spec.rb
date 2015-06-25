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

  it 'should be valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it 'requires a category name' do
    subject.category_name = nil
    expect(subject).not_to be_valid
  end

  it 'requires a database name' do
    subject.database_name = nil
    expect(subject).not_to be_valid
  end

  it 'requires a query' do
    subject.query = nil
    expect(subject).not_to be_valid
  end

  it 'requires a permission key' do
    subject.permission_key = nil
    expect(subject).not_to be_valid
  end

  it 'responds to has_date_range? and has_date_range=' do
    expect(subject).to respond_to :has_date_range?
    expect(subject).to respond_to :has_date_range=
  end

  it 'responds to start_date_default and start_date_default=' do
    expect(subject).to respond_to :start_date_default
    expect(subject).to respond_to :start_date_default=
  end

  it 'requires a start_date_default if the has_date_range? is true' do
    subject.has_date_range = true
    subject.start_date_default = nil
    expect(subject).not_to be_valid
  end

end
