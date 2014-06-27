module ApplicationHelper
  def title( page_title )
    content_for(:title) { page_title }
  end

  def person_area_links(person, classes)
    links = Array.new
    for area in person.areas do
      #TODO Add controller path for areas
      links << link_to(area.name, '#', class: classes)
    end
    links.join(', ').html_safe
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
end
