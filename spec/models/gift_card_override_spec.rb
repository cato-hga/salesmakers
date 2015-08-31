# == Schema Information
#
# Table name: gift_card_overrides
#
#  id                   :integer          not null, primary key
#  creator_id           :integer          not null
#  person_id            :integer          not null
#  original_card_number :string
#  ticket_number        :string
#  override_card_number :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'rails_helper'

describe GiftCardOverride do
  subject { build :gift_card_override }

  it 'validates the uniqueness of the override_card_number' do
    subject.save
    dup = build :gift_card_override, override_card_number: subject.override_card_number
    expect(dup).not_to be_valid
  end
end
