module ApplicationHelper
  def title( page_title )
    content_for(:title) { page_title }
  end

  def person_area_links(person)
    links = Array.new
    for area in person.areas do
      #TODO Add controller path for areas
      links << link_to(area.name, '#')
    end
    links.join(', ').html_safe
  end

  def phone_link(phone)
    phone_string = phone.to_s
    link_to '(' + phone_string[0..2] + ') ' + phone_string[3..5] + '-' + phone_string[6..9], 'tel:' + phone_string
  end
end
