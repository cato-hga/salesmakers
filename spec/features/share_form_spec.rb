require 'rails_helper'

describe 'Share Form' do

  before do
    visit root_path
  end

  describe 'sharing options' do

    it 'should include links to the different share types' do
      within('div.share_form') do
        expect(page).to have_selector('a', text: 'Text')
        expect(page).to have_selector('a', text: 'Photo')
        expect(page).to have_selector('a', text: 'Video')
        expect(page).to have_selector('a', text: 'Link')
      end
    end

    it 'should include the wall drop-down' do
      within('div.share_form') do
        expect(page).to have_selector('select')
      end
    end

    it 'should include the share button' do
      within('div.share_form') do
        expect(page).to have_selector(:link_or_button, 'Share')
      end
    end
  end

  describe 'text sharing' do

    before do
      @random_test_text = (0...12).map { (65 + rand(26)).chr }.join
    end

    it 'should post text posts' do
      within('div#text_tab') do
        fill_in 'text_post_content', with: @random_test_text
        click_on 'Share'
      end
      expect(page).to have_content(@random_test_text)
      visit root_path
      expect(page).to have_content(@random_test_text)
    end
  end

  describe 'image sharing' do
    before do
      @random_test_text = (0...12).map { (65 + rand(26)).chr }.join
      click_on 'Photo'
    end

    it 'should post image posts' do
      within('div#photos_tab') do
        fill_in 'uploaded_image_caption', with: @random_test_text
        attach_file('uploaded_image_image', "#{::Rails.root}/spec/fixtures/files/image.jpg")
        click_on 'Share'
      end
      within('div.post_content') do
        expect(page).to have_content(@random_test_text)
        expect(page).to have_css('img')
        visit root_path
        expect(page).to have_content(@random_test_text)
        expect(page).to have_css('img')
      end
    end
  end

  describe 'video sharing' do
    before do
      @video_test_link = 'https://www.youtube.com/watch?v=0O2aH4XLbto'
    end

    it 'should post video posts' do
      within('div#video_tab') do
        fill_in 'uploaded_video_url', with: @video_test_link
        click_on 'Share'
      end
      expect(page).to have_css('div.video')
      visit root_path
      expect(page).to have_css('div.video')
    end

    it 'should show a video thumbnail if youtube' do
      within('div#video_tab') do
        fill_in 'uploaded_video_url', with: @video_test_link
        click_on 'Share'
      end
      expect(page).to have_css('div.youtube')
      visit root_path
      expect(page).to have_css('div.youtube')
    end
  end

  describe 'link sharing' do

    before do
      @link_test_link = 'http://www.google.com'
      within('div#link_tab') do
        fill_in 'link_post_url', with: @link_test_link
        click_on 'Share'
      end
    end

    it 'should post links' do
      within('div.post_content') do
        expect(page).to have_content('Google')
        visit root_path
        expect(page).to have_content('Google')
      end
    end

    it 'should process and display a web page' do
      within('div.post_content') do
        expect(page).to have_css('img')
      end
    end
  end
end