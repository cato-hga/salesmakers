require 'apis/groupme'
require 'apis/group_me_emoji_filter'
require 'nokogiri'

module ApplicationHelper
  include AutoHtml
  include CommunicationLogHelperExtension
  include DateAndTimeHelperExtension
  include MailerHelperExtension
  include LinksHelperExtension
  include SalesHelperExtension
  include TableHelperExtension

  def title(page_title)
    content_for(:title) { page_title }
  end

  def visible_projects
    Project.visible @current_person
  end

  def icon(name, first_post = false, classes = nil)
    icon_classes = ['fi-' + name]
    icon_classes = [icon_classes, classes].flatten if classes
    content_tag(:i,
                ''.html_safe,
                class: icon_classes,
                id: (first_post ? 'first_post_icon_' + name : nil)).
        html_safe
  end

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

  def emojify(text)
    Emoji.replace_unicode_emoji_with_images text.html_safe
  end

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

  def groupme_emoji_filter(text, attachments)
    GroupMeEmojiFilter.filter(text, attachments).html_safe
  end

  def phone_display(phone_string)
    '(' + phone_string[0..2] + ') ' + phone_string[3..5] + '-' + phone_string[6..9]
  end

  def render_availability(candidate_availability)
    render partial: 'shared/candidate_availability', locals: { candidate_availability: candidate_availability }
  end

  def availability(a, dow, name)
    fa = a["#{name}_first"] ? 'M' : nil
    sa = a["#{name}_second"] ? 'A' : nil
    ta = a["#{name}_third"] ? 'E' : nil
    return nil unless fa or sa or ta
    availability = '<div class="row full-width"><div class="small-6 columns">'.html_safe
    availability += content_tag(:strong, "#{dow}: ")
    availability += '</div><div class="small-6 columns">'.html_safe
    availability += fa if fa
    availability += sa if sa
    availability += ta if ta
    availability += "</div></div>".html_safe
    availability
  end

  def current_client_rep
    controller.current_client_rep
  end
end