require 'rails_helper'

describe 'Wall posts' do

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

  describe "of my own creation" do
    let(:person) { Person.first }
    let(:other_person) { create :person }
    it 'should be shown on the home page' do
      wall = Wall.create wallable: other_person
      text_post = create :text_post,
                         content: 'Herp derp I am a wall post.'
      wall_post = text_post.create_wall_post wall, person
      person.position.permissions.where(key: 'wall_show_all_walls').destroy_all
      visit root_path
      expect(page).to have_content(text_post.content)
    end
  end

  describe 'viewable options (when not authorized)' do
    it 'should not have a delete option'
    it 'should not have a change visibility option'
  end

  describe 'likes' do
    it 'should increase by one when the star is clicked'
    it 'should decrease by one when the star is clicked a second time'
    it 'should not be clickable if it is your own post'
  end

  describe 'change Post Visibility' do
    it 'should change the wall that the post is on'
  end

  describe 'deletion' do
    it 'should delete the Wall Post'
  end
end
