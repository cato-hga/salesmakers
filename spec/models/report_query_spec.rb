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

end