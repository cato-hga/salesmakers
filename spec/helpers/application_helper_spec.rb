require 'rails_helper'

describe ApplicationHelper do
  it 'sets the proper page title content' do
    title = 'My Cool Page'
    title_markup = helper.title title
    expect(view.content_for(:title)).to eq(title)
  end

  it "returns a list of the person's visible projects" do
    all_projects = Project.all
    allow(Project).to receive(:visible).and_return(all_projects)
    expect(helper.visible_projects.count).to eq(1)
  end

  it 'returns no projects if the person has none visible' do
    no_projects = Project.none
    allow(Project).to receive(:visible).and_return(no_projects)
    expect(helper.visible_projects.count).to eq(0)
  end

  it "returns a comma-separated list of all the person's areas" do
    person = Person.first
    first_two_areas = Area.all.limit(2)
    for area in first_two_areas do
      person.areas << area
    end
    area_links_markup = helper.person_area_links person
    expect(area_links_markup).to have_selector('a')
    expect(area_links_markup).to have_content(',')
  end

  describe 'link display methods' do
    it 'displays a link to an area' do
      area = Area.first
      expected_selector = 'a[href="' +
          helper.client_project_area_path(area.project.client,
                                          area.project,
                                          area) +
          '"]'
      link_markup = helper.area_link area
      expect(link_markup).to have_selector(expected_selector)
      expect(link_markup).to have_content(area.name)
    end

    it 'displays a link to a department' do
      department = Department.first
      expected_selector = 'a[href="' +
          helper.department_path(department) +
          '"]'
      link_markup = helper.department_link department
      expect(link_markup).to have_selector(expected_selector)
      expect(link_markup).to have_content(department.name)
    end

    it 'displays a link to a project' do
      project = Project.first
      expected_selector = 'a[href="' +
          helper.client_project_path(project.client, project) +
          '"]'
      link_markup = helper.project_link project
      expect(link_markup).to have_selector(expected_selector)
      expect(link_markup).to have_content(project.name)
    end

    it "displays a link to a phone number" do
      phone_number = '8005551212'
      expected_selector = 'a[href="tel:8005551212"]'
      link_markup = helper.phone_link phone_number, nil
      expect(link_markup).to have_selector(expected_selector)
      expect(link_markup).to have_content('(800) 555-1212')
    end

    it 'displays a link to a person' do
      person = Person.first
      expected_selector = 'a[href="' + helper.person_path(person) + '"]'
      link_markup = helper.person_link person
      expect(link_markup).to have_selector(expected_selector)
      expect(link_markup).to have_content(person.display_name)
    end

    it "displays a link to a person's sales" do
      person = Person.first
      expected_selector = 'a[href="' +
          helper.sales_person_path(person) +
          '"]'
      link_markup = helper.person_sales_link person
      expect(link_markup).to have_selector(expected_selector)
      expect(link_markup).to have_content(person.display_name)
    end

    it "displays a link to an area's sales" do
      area = Area.first
      expected_selector = 'a[href="' +
          helper.sales_client_project_area_path(area.project.client,
                                                area.project,
                                                area) +
          '"]'
      link_markup = helper.area_sales_link area
      expect(link_markup).to have_selector(expected_selector)
      expect(link_markup).to have_content(area.name)
    end

    it "displays a link to a person with their nickname as a social link" do
      person = Person.first
      nickname = 'Big Daddy'
      profile = create :profile,
                       person: person,
                       nickname: nickname
      expected_selector = 'a[href="' +
          helper.person_path(person) +
          '"]'
      link_markup = helper.social_link person
      expect(link_markup).to have_selector(expected_selector)
      expect(link_markup).to have_content(nickname)
    end

    context 'for walls' do
      it 'is correct for areas' do
        wallable = Area.first
        area_link = helper.area_link wallable
        markup = helper.wall_link wallable
        expect(markup).to eq(area_link)
      end

      it 'is correct for departments' do
        wallable = Department.first
        department_link = helper.department_link wallable
        markup = helper.wall_link wallable
        expect(markup).to eq(department_link)
      end

      it 'is correct for projects' do
        wallable = Project.first
        project_link = helper.project_link wallable
        markup = helper.wall_link wallable
        expect(markup).to eq(project_link)
      end

      it 'is correct for someone else' do
        wallable = create :person
        person_link = helper.social_link wallable
        markup = helper.wall_link wallable
        expect(markup).to eq(person_link)
      end

      it 'is correct for me' do
        wallable = Person.first
        @current_person = wallable
        markup = helper.wall_link wallable
        expect(markup).to have_content('Me')
        expect(markup).to have_selector('a')
      end

      it 'shows unknown for something that is not a wall' do
        wallable = create :group_me_user
        markup = helper.wall_link wallable
        expect(markup).to eq('Unknown')
      end
    end
  end

  describe 'table display' do
    let(:headers) { ['One', 'Two', 'Three'] }
    let(:data) { ['Four', 'Five', 'Six'] }

    it 'returns a header row with all fields' do
      header_row_markup = helper.header_row headers
      for header in headers do
        expect(header_row_markup).to have_content(header)
      end
      expect(header_row_markup).to have_selector('th')
    end

    it 'returns a table row' do
      table_row_markup = helper.table_row data
      for cell in data do
        expect(table_row_markup).to have_content(cell)
      end
      expect(table_row_markup).to have_selector('td')
    end

    it 'displays a table' do
      header_row = helper.header_row headers
      data_rows = [table_row(data)]
      table_markup = table header_row, []
      expect(table_markup).to have_content('No records to show.')
      table_markup = table header_row, data_rows, true, '123'
      headers.map { |header| expect(table_markup).to have_content header }
      data.map { |cell| expect(table_markup).to have_content(cell) }
      expect(table_markup).to have_selector('table.th_123')
      expect(table_markup).to have_selector('table tbody tr td')
    end
  end

  # Tests commented out because the methods are not being used.
  # describe 'date display' do
  #   let(:date) { Date.new 2001, 9, 11 }
  #
  #   it 'shows the correct short date format' do
  #     expect(helper.short_date(date)).to eq('09/11/2001')
  #   end
  #
  #   it 'shows the correct medium date format' do
  #     expect(helper.med_date(date)).to eq('Tue, Sep 11, 2001')
  #   end
  #
  #   it 'shows the correct long date format' do
  #     expect(helper.long_date(date)).to eq('Tuesday, September 11, 2001')
  #   end
  # end

  it 'displays a foundation icon properly' do
    icon_name = 'foo'
    icon_markup = helper.icon(icon_name)
    expect(icon_markup).to have_selector('i[class="fi-' + icon_name + '"]')
  end

  it 'converts a name to a filename' do
    name = 'Foo to tha biz-ar'
    expected_filename = 'foo_to_tha_bizar'
    generated_filename = helper.name_to_file_name name
    expect(generated_filename).to eq(expected_filename)
  end

  describe 'log entries' do
    let(:log_entry) {
      build :log_entry,
            created_at: Time.now,
            updated_at: Time.now
    }

    specify 'display in bare form' do
      markup = helper.bare_log_entry log_entry
      expect(markup).to have_content(log_entry.trackable.display_name)
    end

    specify 'display in full form' do
      expected_selector = 'a[href="' +
          helper.person_path(log_entry.trackable) +
          '"]'
      markup = helper.render_log_entry log_entry
      expect(markup).to have_selector(expected_selector)
      expect(markup).to have_content(log_entry.trackable.display_name)
    end
  end

  it 'should display a new button' do
    markup = helper.new_button('/')
    expect(markup).to have_selector('a[href="/"]')
    expect(markup).to have_selector('i[class="fi-plus"]')
  end

  it 'should display an edit button' do
    markup = helper.edit_button('/')
    expect(markup).to have_selector('a[href="/"]')
    expect(markup).to have_selector('i[class="fi-page-edit"]')
  end

  it 'returns the correct last slice of an array' do
    array = [1, 2, 3, 4, 5, 6, 7, 8]
    last_slice = helper.last_slice array, 3
    expect(last_slice).to eq([7, 8])
  end

  it 'generates blank columns to fill in the grid' do
    slices = [1, 2, 3, 4, 5, 6, 7, 8]
    slice = [7, 8]
    markup = empty_columns slices, slice, 3
    expect(markup).to have_selector('.large-4.columns')
  end

  it 'transforms a youtube URL into a marked-up object' do
    url = 'https://www.youtube.com/watch?v=IBYfA3zTxFE'
    expected_src = '//www.youtube.com/embed/IBYfA3zTxFE'
    markup = helper.transform_url url
    expect(markup).to have_selector('.video.youtube')
    expect(markup).to have_selector("iframe[src='#{expected_src}']")
  end

  describe 'wall post display' do
    before(:example) do
      @walls = Wall.all
      @wall_post_comment = WallPostComment.new
      @current_person = Person.first
    end

    it 'shows a text post' do
      text_post = create :text_post
      wall_post = create :wall_post,
                         publication: text_post.publication
      markup = helper.display_post wall_post
      expect(markup).to have_content(text_post.content)
    end

    it 'shows an uploaded video' do
      uploaded_video = create :uploaded_video
      wall_post = create :wall_post,
                         publication: uploaded_video.publication
      expected_src = '//www.youtube.com/embed/IBYfA3zTxFE'
      markup = helper.display_post wall_post
      expect(markup).to have_selector("iframe[src='#{expected_src}']")
    end
  end

  it 'returns an avatar url' do
    person = Person.first
    avatar_url = 'http://retaildoneright.com/me.jpg'
    group_me_user = create :group_me_user,
                           person: person,
                           avatar_url: avatar_url
    url = avatar_url person
    expect(url).to eq(avatar_url + '.avatar')
  end

  describe 'date and time display' do
    it 'is correct on the same day' do
      datetime = Time.now - 3.hours
      output = helper.friendly_datetime(datetime)
      expect(output).to eq(datetime.strftime('%l:%M%P %Z'))
    end

    it 'is correct during the same year' do
      datetime = Time.now - 4.months - 1.day
      output = helper.friendly_datetime(datetime)
      expect(output).to eq(datetime.strftime('%m/%d %l:%M%P %Z'))
    end

    it 'displays the full string if not during this year' do
      datetime = Time.now - 1.year - 2.months - 3.days
      output = helper.friendly_datetime(datetime)
      expect(output).to eq(datetime.strftime('%m/%d/%Y %l:%M%P %Z'))
    end
  end

  it 'displays a sales chart for last month',
     pending: 'groupdate gem is complaining' do
    day_sales_counts = DaySalesCount.none
    markup = past_month_sales_chart day_sales_counts
    expect(markup).to have_selector('.chart_container')
  end

  describe 'ranking display' do
    it 'works with an integer' do
      label = helper.rank_label 1
      expect(label).to have_content('#1')
    end

    it 'displays nothing with a non-integer' do
      label = helper.rank_label 'N/A'
      expect(label).to have_content('N/A')
    end
  end
end