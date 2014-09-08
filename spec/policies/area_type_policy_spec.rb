require 'spec_helper'

describe AreaTypePolicy do

  let(:user) { User.new }

  subject { AreaTypePolicy }

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
