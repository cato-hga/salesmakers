# == Schema Information
#
# Table name: sprint_sales
#
#  id                            :integer          not null, primary key
#  sale_date                     :date             not null
#  person_id                     :integer          not null
#  location_id                   :integer          not null
#  meid                          :string           not null
#  mobile_phone                  :string
#  carrier_name                  :string           not null
#  handset_model_name            :string           not null
#  upgrade                       :boolean          default(FALSE), not null
#  rate_plan_name                :string           not null
#  top_up_card_purchased         :boolean          default(FALSE), not null
#  top_up_card_amount            :float
#  phone_activated_in_store      :boolean          default(FALSE), not null
#  reason_not_activated_in_store :string
#  picture_with_customer         :string
#  comments                      :text
#  connect_sprint_sale_id        :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#

require 'rails_helper'

describe SprintSale do
  subject { build :sprint_sale, sale_date: Date.today }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a sale date' do
    subject.sale_date = nil
    expect(subject).not_to be_valid
  end

  it 'requires a person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

  it 'requires a location' do
    subject.location = nil
    expect(subject).not_to be_valid
  end

  it 'requires an MEID' do
    subject.meid = nil
    expect(subject).not_to be_valid
  end

  it 'requires that MEID be 4 or 18 characters' do
    subject.meid = 'SWAS'
    expect(subject).to be_valid
    subject.meid = 'SWASH'
    expect(subject).not_to be_valid
    subject.meid = '123456789012345678'
    expect(subject).to be_valid
  end

  it 'requires a carrier name' do
    subject.carrier_name = nil
    expect(subject).not_to be_valid
  end

  it 'requires a handset model name' do
    subject.handset_model_name = nil
    expect(subject).not_to be_valid
  end

  it 'requires a rate plan name' do
    subject.rate_plan_name = nil
    expect(subject).not_to be_valid
  end

  it 'requires an upgrade value' do
    subject.upgrade = nil
    expect(subject).not_to be_valid
  end

  it 'requires a top up card purchased value' do
    subject.top_up_card_purchased = nil
    expect(subject).not_to be_valid
  end

  it 'responds to top_up_card_amount' do
    expect(subject).to respond_to(:top_up_card_amount)
  end

  it 'requires a phone activated in store value' do
    subject.phone_activated_in_store = nil
    expect(subject).not_to be_valid
  end

  it 'responds to reason_not_activated_in_store' do
    expect(subject).to respond_to(:reason_not_activated_in_store)
  end

  it 'responds to comments' do
    expect(subject).to respond_to(:comments)
  end

  it 'responds to connect_sprint_sale' do
    expect(subject).to respond_to(:connect_sprint_sale)
  end
end
