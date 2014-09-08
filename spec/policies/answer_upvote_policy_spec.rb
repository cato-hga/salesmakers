require 'spec_helper'

describe AnswerUpvotePolicy do

  let(:user) { User.new }

  subject { AnswerUpvotePolicy }

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
