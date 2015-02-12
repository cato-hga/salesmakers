class SimpleSpreadsheet
  attr_reader :header_row, :rows, :hashes

  def initialize(roo_spreadsheet)
    @roo_spreadsheet = roo_spreadsheet
    @header_row, @rows, @hashes = [], [], []
    process
  end

  def process
    longest_row_length = find_longest_row_length
    set_header_and_rows(longest_row_length)
    make_hashes
  end

  def set_header_and_rows(longest_row_length)
    @roo_spreadsheet.each_row_streaming do |row|
      next unless has_coordinate?(row)
      if row.length == longest_row_length and @header_row.empty?
        @header_row = @roo_spreadsheet.row(row.first.coordinate.row)
        next
      end
      @rows << @roo_spreadsheet.row(row.first.coordinate.row) unless @header_row.empty?
    end
  end

  def find_longest_row_length
    max_length = 0
    @roo_spreadsheet.each_row_streaming do |row|
      max_length = row.length if row.length > max_length
    end
    max_length
  end

  def make_hashes
    for row in self.rows do
      hashes << Hash[self.header_row.zip(row)]
    end
  end

  private

  def has_coordinate?(row)
    not row.empty? and row.first.coordinate
  end
end