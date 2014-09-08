require 'spec_helper'

describe AreaPolicy do

  let(:user) { User.new }

  subject { AreaPolicy }

  permissions ".scope" do
  end

  permissions :create? do
  end

  permissions :show? do
  end

  permissions :update? do
  end

  permissions :destroy? do
  end
end
