require 'rails_helper'

describe 'Wall Post' do

  before do
    create :it_wall_post
    visit root_path
  end

  describe 'viewable actions (when authorized)' do
    it 'should include an Add Comment link' do
      within('.actions') do
        expect(page).to have_css('a#first_post_add_comment')
      end
    end

    it 'should include a link to change Post Visibility for authorized users' do
      within('.actions') do
        expect(page).to have_css('span.show_change_wall_form')
      end
    end

    it 'should include a delete option for authorized users' do
      #save_and_open_page
      within('.actions') do
        expect(page).to have_css('a#first_post_delete')
      end
    end

    it 'should include a star for liking' do
      within('.post_actions') do
        expect(page).to have_css('i#first_post_icon_star')
      end
    end
  end

  describe 'viewable options (when not authorized)' do
    it 'should not have a delete option' do
    end

    it 'should not have a change visibility option' do
    end
  end

  describe 'likes' do
    it 'should increase by one when the star is clicked' do
    end

    it 'should decrease by one when the star is clicked a second time' do
    end

    it 'should not be clickable if it is your own post' do
    end
  end

  describe 'change Post Visibility' do
    it 'should change the wall that the post is on' do
    end
  end

  describe 'deletion' do
    it 'should delete the Wall Post' do
    end
  end
end
