require 'rails_helper'

describe 'Factory Girl' do
  let!(:vonage_mac_prefix) { create :vonage_mac_prefix }

  it 'lints factories successfully' do
    factories_to_lint = FactoryGirl.factories.reject do |factory|
      factory.name =~ /^connect_/
    end

    FactoryGirl.lint factories_to_lint
  end
end