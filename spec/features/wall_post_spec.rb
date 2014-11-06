require 'rails_helper'

describe 'Wall posts' do

  describe 'viewable actions (when authorized)' do
    before(:example) do
      visit root_path
    end

    it 'should include an Add Comment link' do
      within('#first_post .actions') do
        expect(page).to have_css('a#first_post_add_comment')
      end
    end

    it 'should include a link to change Post Visibility for authorized users' do
      within('.widget:last-of-type .actions') do
        expect(page).to have_css('span.show_change_wall_form')
      end
    end

    it 'should include a delete option for authorized users' do
      within('#first_post .actions') do
        expect(page).to have_css('a#first_post_delete')
      end
    end

    it 'should include a star for liking' do
      within('#first_post .post_actions') do
        expect(page).to have_css('i#first_post_icon_star')
      end
    end
  end

  describe "of my own creation" do
    let(:wall_post) { create :it_wall_post }
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
    let(:person) { Person.first }

    before(:example) do
      person.position.permissions.destroy_all
      person.position.update(hq: false)
      visit root_path
    end

    it 'should not have a delete option' do
      within('#first_post .actions') do
        expect(page).not_to have_selector('a', text: 'Delete')
      end
    end

    it 'should not have a change visibility option' do
      within('.widget:last-of-type .actions') do
        expect(page).not_to have_css('span.show_change_wall_form')
      end
    end
  end

  describe 'likes' do
    before(:example) do
      create :non_it_wall_post
      visit root_path
    end

    it 'increases by one when the star is clicked' do
      expect {
        page.find('a.unliked:first-of-type').click
      }.to change(Like, :count).by(1)
    end

    it 'decreases by one when the star is clicked a second time' do
      page.find('a.unliked:first-of-type').click
      visit root_path
      expect {
        page.find('a.liked:first-of-type').click
      }.to change(Like, :count).by(-1)
    end

    it 'is not be clickable if it is your own post' do
      WallPost.destroy_all
      post = create :it_wall_post,
                    person: Person.first
      visit root_path
      expect(page).not_to have_selector('a.unliked')
    end
  end

  context 'when post visibility is changed' do
    specify 'the wall that the post is on changes',
            pending: 'need js: true which is not functioning properly' do
      visit root_path
      post = WallPost.find_by wall: Department.first.wall
      within('.widget:last-of-type .actions') do
        find('a', text: 'Change Post Visibility').click
        select('RBD Project - Project', from: 'wall_post_wall_id')
        expect {
          find('a.change_wall_submit').click
          post.reload
        }.to change(post, :wall_id)
      end
    end
  end

  describe 'deletion' do
    it 'deletes the Wall Post'
  end

end
