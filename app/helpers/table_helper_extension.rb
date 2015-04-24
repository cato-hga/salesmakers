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

  def table_row(data, classes = nil)
    content = ''.html_safe
    for cell in data
      content = content + content_tag(:td, cell, class: classes)
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

  def generate_subtotal_rows rows, transform_from_string_to = :to_i, number_columns_to_subtotal = 1
    new_rows_list = []
    change_index = number_columns_to_subtotal * -1 - 2
    value = rows.first[change_index]
    subtotals = get_zero_subtotals number_columns_to_subtotal, transform_from_string_to
    Rails.logger.debug "ZERO SUBTOTALS: #{subtotals.inspect}"
    for row in rows do
      if row[change_index] != value
        new_rows_list << get_total_row(value, rows.first.length, subtotals, number_columns_to_subtotal)
        subtotals = get_zero_subtotals number_columns_to_subtotal, transform_from_string_to
        Rails.logger.debug "ZEROING: #{subtotals.inspect}"
      end
      value = row[change_index]
      Rails.logger.debug "BEFORE: #{subtotals.inspect}"
      Rails.logger.debug "SALES: #{row[-3]}"
      subtotals = get_subtotal_array_from_row subtotals, row, transform_from_string_to, number_columns_to_subtotal
      Rails.logger.debug "AFTER: #{subtotals.inspect}"
      new_rows_list << row
    end
    new_rows_list << get_total_row(value, rows.first.length, subtotals, number_columns_to_subtotal)
    new_rows_list
  end

  def get_subtotal_array_from_row current_subtotals, row, transform_from_string_to, number_columns_to_subtotal
    subtotals = []
    number_columns_to_subtotal.times do |i|
      subtotals << current_subtotals.reverse[i] + row[(i+1)*-1].send(transform_from_string_to)
    end
    subtotals.reverse
  end

  def get_zero_subtotals number_columns_to_subtotal, transform_from_string_to
    subtotals = []
    number_columns_to_subtotal.times do
      subtotals << '0'.send(transform_from_string_to)
    end
    subtotals
  end

  def get_total_row value, length, subtotals, number_columns_to_subtotal
    total_row = Array.new(length - number_columns_to_subtotal - 1)
    total_row[-1] = '[TOTAL] '.html_safe + (value ? value.html_safe : '')
    total_row << nil
    total_row.concat subtotals
  end
end
