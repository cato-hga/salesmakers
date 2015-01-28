require 'apis/groupme'

module ApplicationHelper
  include AutoHtml

  def title(page_title)
    content_for(:title) { page_title }
  end

  def visible_projects
    Project.visible @current_person
  end

  def person_area_links(person, classes = [])
    links = Array.new
    for area in person.areas do
      links << link_to(area.name, client_project_area_url(area.project.client, area.project, area), class: classes)
    end
    links.join(', ').html_safe
  end

  def area_link(area)
    link_to area.name, client_project_area_url(area.project.client, area.project, area)
  end

  def department_link(department)
    link_to department.name, department
  end

  def project_link(project)
    link_to project.name, [project.client, project]
  end

  def phone_link(phone, classes = nil)
    return unless phone
    phone_string = phone.to_s
    link_to '(' + phone_string[0..2] + ') ' + phone_string[3..5] + '-' + phone_string[6..9], 'tel:' + phone_string, class: classes
  end

  def csv_link(path, record_count)
    if record_count >= 1000
      data_attributes = {
          confirm: 'Exporting this many records could take a while. After clicking OK, please wait for the export to complete.',
          attachment: true
      }
    else
      data_attributes = { attachment: true }
    end
    link_to 'csv', path, class: [:button, :inline_button], data: data_attributes
  end

  def email_link(email, classes = nil)
    return unless email
    mail_to email, email, classes: classes
  end

  def table(header, rows, show_count = true, tag = nil)
    if tag
      tag = 'th_' + tag.to_s
    else
      tag = @random_tag
    end
    if rows.count > 0
      table_content = ''.html_safe
      table_content = table_content + content_tag(:thead, content_tag(:tr, header))
      table_rows = ''.html_safe
      for row in rows
        table_rows = table_rows + content_tag(:tr, row)
      end
      table_content = table_content + content_tag(:tbody, table_rows)
      count_indicator = (@search.present? and show_count) ? content_tag(:div, @search.result.count.to_s + ' records found', class: 'record_count') : ''.html_safe
      count_indicator + content_tag(:table, table_content, class: ['table', 'table-hover', tag])
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

  def header_row(titles, tag = Random.rand(1000000))
    content = ''.html_safe
    @random_tag = 'th_' + tag.to_s
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

  #:nocov:
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
  #:nocov:

  def short_date(date)
    return '' unless date
    date.strftime '%m/%d/%Y'
  end

  def med_date(date)
    date.strftime '%a, %b %-d, %Y'
  end

  def long_date(date)
    date.strftime '%A, %B %-d, %Y'
  end

  def icon(name, first_post = false)
    content_tag(:i, ''.html_safe, class: 'fi-' + name, id: (first_post ? 'first_post_icon_' + name : nil)).html_safe
  end

  def person_link(person, classes = nil)
    classes = tack_on_inactive_class(person, classes)
    link = link_to person.display_name, person_url(person), class: classes
    if person.mobile_phone and
        not person.mobile_phone.include? '8005551212'
      link = link + contact_link(person)
    end
    link
  end

  def contact_link(person)
    link_to icon('megaphone'), new_sms_message_person_url(person), class: [:send_contact]
  end

  def person_sales_link(person, classes = nil)
    classes = tack_on_inactive_class(person, classes)
    link_to NameCase(person.display_name), sales_person_url(person), class: classes
  end

  def tack_on_inactive_class(person, classes)
    if classes and classes.is_a? String
      classes = [classes]
    end
    extra_classes = person.active? ? [] : [:inactive]
    if classes
      classes = classes.zip(extra_classes).flatten.compact.uniq
    else
      classes = extra_classes
    end
    classes
  end

  def area_sales_link(area, classes = '')
    link_to area.name, sales_client_project_area_url(area.project.client, area.project, area), class: classes
  end

  # def social_link(person, classes = '')
  #   name = person.social_name.length < 4 ? person.social_name : NameCase(person.social_name)
  #   link_to name, person, class: classes
  # end

  def bare_log_entry(log_entry)
    render "log_entries/bare_log_entry", log_entry: log_entry
  end

  def name_to_file_name(name)
    name = name.gsub(' ', '_')
    name = name.gsub(/[^A-Za-z0-9_]/, '')
    name.underscore
  end

  def render_log_entry(log_entry)
    render "log_entries/log_entry", log_entry: log_entry
  end

  #:nocov:
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
    image_file = 'devices/' + device.device_model_name.gsub(/[^A-Za-z0-9]/, '').gsub(' ', '_').underscore + '.png'
    image = Rails.application.assets.find_asset image_file
    if image.present?
      image_tag image_file, class: 'device_thumb'
    else
      ''
    end
  end

  def line_service_provider_image(line)
    service_provider = line.technology_service_provider
    service_provider_name = name_to_file_name service_provider.name
    image_file = 'service_providers/' + service_provider_name + '.png'
    image = Rails.application.assets.find_asset image_file
    if image.present?
      image_tag image_file, class: 'service_provider_thumb'
    else
      ''
    end
  end

  # Not currently being used

  # def device_service_provider_image(device)
  #   image_file = 'service_providers/' + device.technology_service_provider.name.gsub(/[^A-Za-z0-9]/, '').gsub(' ', '_').underscore + '.png'
  #   image = Rails.application.assets.find_asset image_file
  #   if image.present?
  #     image_tag image_file, class: 'service_provider_thumb'
  #   else
  #     ''
  #   end
  # end

  def line_link(line)
    line_string = line.identifier
    return line_string unless line_string.length == 10
    link_to '(' + line_string[0..2] + ') ' + line_string[3..5] + '-' + line_string[6..9], line
  end

  def line_display(line)
    line_string = line.identifier
    return line_string unless line_string.length == 10
    '(' + line_string[0..2] + ') ' + line_string[3..5] + '-' + line_string[6..9]
  end
  #:nocov:

  def new_button(path)
    link_to icon('plus') + ' New', path, class: [:button, :rounded, :inline_button], id: 'new_action_button'
  end

  def edit_button(path)
    link_to icon('page-edit') + ' Edit', path, class: [:button, :rounded, :inline_button]
  end

  def delete_button(path)
    link_to icon('x-circle') + ' Delete',
            path,
            class: [:button, :rounded, :inline_button],
            id: 'delete_action_button',
            method: :delete,
            data: { confirm: 'This action cannot be undone! Are you sure?' }
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

  #:nocov:
  # WTF? Don't know how to test this.
  def emojify(text)
    Emoji.replace_unicode_emoji_with_images text.html_safe
  end
  #:nocov:

  def transform_url(url)
    auto_html url do
      html_escape
      image
      #video_center
      youtube(autoplay: false)
      vimeo(show_title: true, show_byline: true)
      link target: "_blank", rel: "nofollow"
    end
  end

  # def display_post(post, first_post = false, hide = false)
  #   publication = post.publication
  #   return unless publication
  #   publishable = publication.publishable
  #   if publishable.is_a? TextPost
  #     return render partial: 'text_posts/text_post', locals: { post: post, first_post: first_post, hidden: hide, walls: @walls, visible_people: @visible_people, current_person: @current_person }, layout: 'layouts/widget'
  #   #:nocov:
  #   # Testing with DragonFly?
  #   elsif publishable.is_a? UploadedImage
  #     return render partial: 'uploaded_images/uploaded_image', locals: { post: post, first_post: first_post, hidden: hide, walls: @walls, visible_people: @visible_people, current_person: @current_person }, layout: 'layouts/widget'
  #   #:nocov:
  #   elsif publishable.is_a? UploadedVideo
  #     return render partial: 'uploaded_videos/uploaded_video', locals: { post: post, first_post: first_post, hidden: hide, walls: @walls, visible_people: @visible_people, current_person: @current_person }, layout: 'layouts/widget'
  #   #:nocov:
  #   # Testing with Dragonfly?
  #   elsif publishable.is_a? LinkPost
  #     return render partial: 'link_posts/link_post', locals: { post: post, first_post: first_post, hidden: hide, walls: @walls, visible_people: @visible_people, current_person: @current_person }, layout: 'layouts/widget'
  #   #:nocov:
  #   end
  #   nil
  # end

  def avatar_url(person)
    return person.profile_avatar_url if person.profile_avatar
    return person.group_me_avatar_url + '.avatar' if person.group_me_avatar_url
    default_url = asset_url 'default_avatar.jpg'
    gravatar_id = Digest::MD5::hexdigest(person.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?d=#{CGI.escape(default_url)}"
  end

  def avatar(person)
    link_to image_tag(avatar_url(person), class: :avatar), person_url(person)
  end

  def friendly_datetime(datetime)
    if datetime.strftime('%m/%d/%Y') == Time.now.strftime('%m/%d/%Y')
      datetime.strftime('%l:%M%P %Z')
    elsif datetime.year == Time.now.year
      datetime.strftime('%m/%d %l:%M%P %Z')
    else
      datetime.strftime('%m/%d/%Y %l:%M%P %Z')
    end
  end

  # def wall_link(wallable)
  #   return nil unless wallable
  #   if wallable.is_a? Area
  #     area_link wallable
  #   elsif wallable.is_a? Department
  #     department_link wallable
  #   elsif wallable.is_a? Project
  #     project_link wallable
  #   elsif wallable.is_a? Person
  #     if wallable == @current_person
  #       link_to 'Me', @current_person
  #     else
  #       social_link wallable
  #     end
  #   else
  #     'Unknown'
  #   end
  # end

  # def likes(post, first_post = false)
  #   if post.likes.where(person: @current_person, wall_post: post).count > 0 and post.publication.publishable.person != @current_person
  #     #content_tag :div, icon('star') + ' &times; '.html_safe + content_tag(:span, post.likes.count.to_s, class: :count), class: :liked
  #     link_to(icon('star', first_post), destroy_like_url(post.id), class: :liked, remote: true, id: 'unlike-' + post.id.to_s) + ' &times; '.html_safe + content_tag(:span, post.likes.count.to_s, class: :count) + '<script type="text/javascript">$(function(){setupUnlikeEvent('.html_safe + post.id.to_s + ');});</script>'.html_safe
  #   elsif post.publication.publishable.person == @current_person
  #     content_tag(:span, icon('star', first_post), class: :own_like) + ' &times; '.html_safe + content_tag(:span, post.likes.count.to_s, class: :count)
  #   else
  #     link_to(icon('star', first_post), create_like_url(post.id), class: :unliked, remote: true, id: 'like-' + post.id.to_s) + ' &times; '.html_safe + content_tag(:span, post.likes.count.to_s, class: :count) + '<script type="text/javascript">$(function(){setupLikeEvent('.html_safe + post.id.to_s + ');});</script>'.html_safe
  #   end
  # end

  def past_month_sales_chart(day_sales_counts)
    content_tag :div,
                #link_to('Show/Hide Chart', '#', class: 'toggle_chart') +
                sales_line_chart(day_sales_counts),
                class: 'chart_container'
  end

  def sales_line_chart(day_sales_counts)
    line_chart day_sales_counts.
                   for_range((Date.today - 1.month)..Date.today).
                   group_by_day(:day).sum(:sales)
  end

  #:nocov:
  # IT'S JUST MATH, people
  def week_run_rate_multiplier
    (7 * 24 * 60 * 60) / (Time.now - Time.now.beginning_of_week)
  end

  def month_run_rate_multiplier
    (((Date.today.beginning_of_month + 1.month) - Date.today.beginning_of_month) * 24 * 60 * 60) / (Time.now - Time.now.beginning_of_month)
  end

  def year_run_rate_multiplier
    (((Date.today.beginning_of_year + 1.year) - Date.today.beginning_of_year) * 24 * 60 * 60) / (Time.now - Time.now.beginning_of_year)
  end
  #:nocov:

  def groupme_emoji_filter(text, attachments)
    GroupMeEmojiFilter.filter(text, attachments).html_safe
  end

  def rank_label(rank)
    is_integer = rank.is_a?(Integer) ? true : false
    rank = rank.to_s
    rank = '#' + rank if is_integer
    ' '.html_safe + content_tag(:span, rank, class: [:label, :round, :secondary])
  end

  def communication_log_from(entry)
    if entry.loggable_type == 'SMSMessage'
      sms_communication_log_from(entry)
    elsif entry.loggable_type == 'EmailMessage'
      email_communication_log_from(entry)
    end
  end

  def sms_communication_log_from(entry)
    message = entry.loggable
    if message.from_person
      person_link message.from_person
    else
      phone_link message.from_num
    end
  end

  def email_communication_log_from(entry)
    email = entry.loggable
    email_link email.from_email
  end

  def communication_log_to(entry)
    if entry.loggable_type == 'SMSMessage'
      sms_communication_log_to(entry)
    elsif entry.loggable_type == 'EmailMessage'
      email_communication_log_to(entry)
    end
  end

  def sms_communication_log_to(entry)
    message = entry.loggable
    if message.to_person
      person_link message.to_person
    else
      phone_link message.to_num
    end
  end

  def email_communication_log_to(entry)
    email = entry.loggable
    if email.to_person
      person_link email.to_person
    else
      email_link email.to_email
    end
  end

  def communication_log_display(entry)
    if entry.loggable_type == 'SMSMessage'
      sms_communication_log_display(entry)
    elsif entry.loggable_type == 'EmailMessage'
      email_communication_log_display(entry)
    end
  end

  def sms_communication_log_display(entry)
    content_tag :span, entry.loggable.message, class: [:comment]
  end

  def email_communication_log_display(entry)
    'Email: '.html_safe + content_tag(:span, entry.loggable.subject, class: [:comment])
  end
end
