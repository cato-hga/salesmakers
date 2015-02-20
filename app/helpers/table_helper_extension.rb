module TableHelperExtension
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
    render partial: 'shared/table_header', locals: {
                                             titles: titles,
                                             stripped_titles: strip_titles(titles),
                                             random_tag: '.' + @random_tag
                                         }
  end

  def strip_titles(titles)
    stripped = Array.new
    for cell in titles do
      html = Nokogiri::HTML(cell)
      stripped << html.text
    end
    stripped
  end
end
