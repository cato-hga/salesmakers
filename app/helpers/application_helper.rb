module ApplicationHelper
  include AutoHtml

  def title( page_title )
    content_for(:title) { page_title }
  end

  def visible_projects
    Project.visible @current_person
  end

  def person_area_links(person, classes = [])
    links = Array.new
    for area in person.areas do
      links << link_to(area.name, client_project_area_path(area.project.client, area.project, area), class: classes)
    end
    links.join(', ').html_safe
  end

  def area_link(area)
    link_to area.name, client_project_area_path(area.project.client, area.project, area)
  end

  def phone_link(phone,classes)
    phone_string = phone.to_s
    link_to '(' + phone_string[0..2] + ') ' + phone_string[3..5] + '-' + phone_string[6..9], 'tel:' + phone_string, class: classes
  end

  def table(header, rows, show_count = true)
    if rows.count > 0
      table_content = ''.html_safe
      table_content = table_content + content_tag(:thead, content_tag(:tr, header))
      table_rows = ''.html_safe
      for row in rows
        table_rows = table_rows + content_tag(:tr, row)
      end
      table_content = table_content + content_tag(:tbody, table_rows)
      count_indicator = (@search.present? and show_count) ? content_tag(:div, @search.result.count.to_s + ' records found', class: 'record_count') : ''.html_safe
      count_indicator + content_tag(:table, table_content, class: ['table', 'table-hover', @random_tag])
    else
      content_tag(:div, 'No records to show.', class: 'empty')
    end
  end

  def table_row(data)
    content = ''.html_safe
    for cell in data
      content = content + content_tag(:td, cell)
    end
    content
  end

  def header_row(titles)
    content = ''.html_safe
    @random_tag = 'th_' + Random.rand(1000000).to_s
    for cell in titles
      content = content + content_tag(:th, cell)
    end
    styling = ''.html_safe
    styling << '<style type="text/css">'.html_safe
    styling << '@media only screen and (max-width: 800px) {'.html_safe
    header_index = 0
    for cell in titles
      header_index = header_index + 1
      styling << '.' + @random_tag + ' td:nth-of-type('.html_safe
      styling << header_index.to_s.html_safe
      styling << '):before { content: "'.html_safe
      styling << cell.html_safe
      styling << '"; } '.html_safe
    end
    styling << '}'.html_safe
    styling << '</style>'.html_safe
    content << styling.html_safe
    content
  end

  def line_state_links(line)
    links = Array.new
    for state in line.line_states do
      links << link_to(state.name, line)
    end
    links.join(', ').html_safe
  end

  def device_state_links(device)
    links = Array.new
    for state in device.device_states do
      links << link_to(state.name, device)
    end
    links.join(', ').html_safe
  end

  def short_date(date)
    date.strftime '%m/%d/%Y'
  end

  def med_date(date)
    date.strftime '%a, %b %-d, %Y'
  end

  def long_date(date)
    date.strftime '%A, %B %-d, %Y'
  end

  def icon(name)
    content_tag(:i, ''.html_safe, class: 'fi-' + name).html_safe
  end

  def person_link(person, classes = '')
    link_to NameCase(person.display_name), person, class: classes
  end

  def bare_log_entry(log_entry)
    render "log_entries/bare_log_entry", log_entry: log_entry
  end

  def render_log_entry(log_entry)
    render "log_entries/log_entry", log_entry: log_entry
  end

  def device_link(device)
    link_to device.serial, device
  end

  def tracking_link(tracking_number, text = nil)
    if text == nil
      text = tracking_number
    end
    link_to text, 'http://www.fedex.com/Tracking?action=track&tracknumbers=' + tracking_number, target: '_blank'
  end

  def device_image(device)
    image_file = 'devices/' + @device.model_name.gsub(/[^A-Za-z0-9]/, '').gsub(' ', '_').underscore + '.png'
    image = Rails.application.assets.find_asset image_file
    if image.present?
      image_tag image_file, class: 'device_thumb'
    else
      ''
    end
  end

  def line_service_provider_image(line)
    image_file = 'service_providers/' + line.technology_service_provider.name.gsub(/[^A-Za-z0-9]/, '').gsub(' ', '_').underscore + '.png'
    image = Rails.application.assets.find_asset image_file
    if image.present?
      image_tag image_file, class: 'service_provider_thumb'
    else
      ''
    end
  end

  def device_service_provider_image(device)
    image_file = 'service_providers/' + device.technology_service_provider.name.gsub(/[^A-Za-z0-9]/, '').gsub(' ', '_').underscore + '.png'
    image = Rails.application.assets.find_asset image_file
    if image.present?
      image_tag image_file, class: 'service_provider_thumb'
    else
      ''
    end
  end

  def line_link(line)
    line_string = line.identifier
    return line_string unless line_string.length == 10
    link_to '(' + line_string[0..2] + ') ' + line_string[3..5] + '-' + line_string[6..9], line
  end

  def render_log_entry(log_entry)
    render "log_entries/log_entry", log_entry: log_entry
  end

  def line_display(line)
    line_string = line.identifier
    return line_string unless line_string.length == 10
    '(' + line_string[0..2] + ') ' + line_string[3..5] + '-' + line_string[6..9]
  end

  def new_button(path)
    link_to icon('plus') + ' New', path, class: [:button, :tiny, :rounded, :inline_button]
  end

  def last_slice(array, i)
    last_slice = (array.count % i == 0) ? i : array.count % i
    array.last(last_slice)
  end

  def empty_columns(slices, slice, columns, classes = [])
    empty_columns = ''.html_safe
    grid_columns = 12 / columns
    all_classes = []
    all_classes << ["large-#{grid_columns}", 'columns']
    all_classes << classes
    if slice == last_slice(slices, columns) and columns % slice.count > 0
      (columns % slice.count).times do
        empty_columns += content_tag(:div, '', class: all_classes)
      end
    end
    empty_columns
  end

  def emojify(text)
    Emoji.replace_unicode_moji_with_images text.html_safe
  end

  def transform_url(url)
    auto_html url do
      html_escape
      image
      youtube( autoplay: false)
      vimeo(show_title: true, show_byline: true)
      link target: "_blank", rel: "nofollow"
    end
  end

  def display_post(post)
    if post.is_a? TextPost
      return render partial: 'text_posts/text_post', locals: { post: post }, layout: 'layouts/widget'
    elsif post.is_a? UploadedImage
      return render partial: 'uploaded_images/uploaded_image', locals: { post: post }, layout: 'layouts/widget'
    elsif post.is_a? UploadedVideo
      return render partial: 'uploaded_videos/uploaded_video', locals: { post: post }, layout: 'layouts/widget'
    end
    nil
  end

  def avatar_url(person)
    gravatar_id = Digest::MD5::hexdigest(person.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png"
  end
end
