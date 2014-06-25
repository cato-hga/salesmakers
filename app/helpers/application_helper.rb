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
end
