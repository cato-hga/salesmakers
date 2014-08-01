require 'rails_helper'

RSpec.describe PermissionGroupsController, :type => :controller do

  Capybara.current_session.driver.header 'Referer', '/'

  describe 'Policy violations' do

    it 'denies access to index without permission' do
      permission_group = create :permission_group
      person = create :person
      log_in person
      visit permission_groups_path
      expect(page).to redirect_to :back
    end

    it 'denies access to show without permission' do
      pending
    end

    it 'denies access to new without permission' do
      pending
    end

    it 'denies access to create without permission' do
      pending
    end

    it 'denies access to edit without permission' do
      pending
    end

    it 'denies access to update without permission' do
      pending
    end

    it 'denies access to destroy without permission' do
      pending
    end

  end

  describe 'Policy authorizations' do

    it 'allows access to index with permission' do
      pending
    end

    it 'allows access to show with permission' do
      pending
    end

    it 'allows access to new with permission' do
      pending
    end

    it 'allows access to create with permission' do
      pending
    end

    it 'allows access to edit with permission' do
      pending
    end

    it 'allows access to update with permission' do
      pending
    end

    it 'allows access to destroy with permission' do
      pending
    end

  end
end
