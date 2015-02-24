module TableHelperExtension
  def table(header, rows, show_count = true, tag = nil)
    tag = tag ? 'th_' + tag.to_s : @random_tag
    if rows.count > 0
      generate_table_content(header, rows, show_count, tag)
    else
      content_tag(:div, 'No records to show.', class: 'empty')
    end
  end

  def generate_table_content(header, rows, show_count, tag)
    table_content, table_rows = ''.html_safe, ''.html_safe
    table_content += content_tag(:thead, content_tag(:tr, header))
    rows.each { |row| table_rows += content_tag(:tr, row) }
    table_content += content_tag(:tbody, table_rows)
    count_indicator(show_count) +
        content_tag(:table, table_content, class: ['table', 'table-hover', tag])
  end

  def count_indicator(show_count)
    if @search.present? and show_count
      content_tag(:div, @search.result.count.to_s + ' records found', class: 'record_count')
    else
      ''.html_safe
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
