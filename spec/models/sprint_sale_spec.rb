# == Schema Information
#
# Table name: sprint_sales
#
#  id                                   :integer          not null, primary key
#  sale_date                            :date             not null
#  person_id                            :integer          not null
#  location_id                          :integer          not null
#  meid                                 :string
#  mobile_phone                         :string
#  upgrade                              :boolean          default(FALSE), not null
#  top_up_card_purchased                :boolean          default(FALSE)
#  top_up_card_amount                   :float
#  phone_activated_in_store             :boolean          default(FALSE)
#  reason_not_activated_in_store        :string
#  picture_with_customer                :string
#  comments                             :text
#  connect_sprint_sale_id               :string
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  project_id                           :integer
#  number_of_accessories                :integer
#  sprint_carrier_id                    :integer
#  sprint_handset_id                    :integer
#  sprint_rate_plan_id                  :integer
#  five_intl_connect                    :boolean
#  ten_intl_connect                     :boolean
#  insurance                            :boolean
#  virgin_data_share_add_on_amount      :float
#  virgin_data_share_add_on_description :text
#

require 'rails_helper'

describe SprintSale do
  let!(:prepaid_project) { create :project, name: 'Sprint Retail' }
  let!(:postpaid_project) { create :project, name: 'Sprint Postpaid' }
  subject { build :sprint_sale, sale_date: Date.today, project: prepaid_project }

  it 'requires a person' do
    subject.person_id = nil
    expect(subject).not_to be_valid
  end

  it 'requires a valid sale date' do
    subject.sale_date = nil
    expect(subject).not_to be_valid
    subject.sale_date = 32.days.ago
    expect(subject).not_to be_valid
    subject.sale_date = 'totallywrongdate'
    expect(subject).not_to be_valid
    subject.sale_date = Date.today
    expect(subject).to be_valid
  end

  it 'requires a location' do
    subject.location_id = nil
    expect(subject).not_to be_valid
  end

  it 'requires an upgrade value' do
    subject.upgrade = nil
    expect(subject).not_to be_valid
  end

  it 'requires a handset' do
    subject.sprint_handset_id = nil
    expect(subject).not_to be_valid
  end

  it 'requires a rateplan value' do
    subject.sprint_rate_plan_id = nil
    expect(subject).not_to be_valid
  end

  it 'requires that MEID be 18 numbers' do
    subject.project_id = prepaid_project.id
    subject.meid = '123456789012345678'
    expect(subject).to be_valid
  end

  it 'requires a mobile phone number' do
    subject.mobile_phone = nil
    expect(subject).not_to be_valid
  end

  it 'requires a product' do
    subject.sprint_carrier_id = nil
    expect(subject).not_to be_valid
  end

  it 'requires a top up card purchased value' do
    subject.top_up_card_purchased = nil
    expect(subject).not_to be_valid
  end

  it 'requires top_up_card_amount if top up card was purchased' do
    subject.top_up_card_purchased = true
    subject.top_up_card_amount = nil
    expect(subject).not_to be_valid
  end

  it 'requires a phone activated in store value' do
    subject.phone_activated_in_store = nil
    expect(subject).not_to be_valid
  end

  it 'requires reason_not_activated_in_store if phone was not activated in store' do
    subject.phone_activated_in_store = false
    subject.reason_not_activated_in_store = nil
    expect(subject).not_to be_valid
  end

  it 'requires a picture with customer value' do
    subject.picture_with_customer = nil
    expect(subject).not_to be_valid
  end

  it 'responds to top_up_card_amount' do
    expect(subject).to respond_to(:top_up_card_amount)
  end

  it 'responds to reason_not_activated_in_store' do
    expect(subject).to respond_to(:reason_not_activated_in_store)
  end

  it 'responds to comments' do
    expect(subject).to respond_to(:comments)
  end

  it 'responds to five_intl_connect' do
    expect(subject).to respond_to(:five_intl_connect)
  end

  it 'responds to ten_intl_connect' do
    expect(subject).to respond_to(:ten_intl_connect)
  end

  it 'responds to insurance' do
    expect(subject).to respond_to(:insurance)
  end

  it 'responds to virgin_data_share_add_on_amount' do
    expect(subject).to respond_to(:virgin_data_share_add_on_amount)
  end

  it 'responds to virgin_data_share_add_on_description' do
    expect(subject).to respond_to(:virgin_data_share_add_on_description)
  end

  it 'responds to connect_sprint_sale' do
    expect(subject).to respond_to(:connect_sprint_sale)
  end

  it 'responds to photo' do
    expect(subject).to respond_to :photo
  end

  context 'validation for postpaid only' do
    let!(:prepaid_project) { create :project, name: 'Sprint Retail' }
    let!(:postpaid_project) { create :project, name: 'Sprint Postpaid' }
    subject { build :sprint_sale, sale_date: Date.today, project: postpaid_project }

    it 'requires number of accessories' do
      subject.number_of_accessories = nil
      expect(subject).not_to be_valid
    end
  end
end
