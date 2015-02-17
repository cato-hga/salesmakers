module NonAlphaNumericRansacker
  def stripping_ransacker(ransacker_name, cell_name, allow_alpha = false)
    regex = allow_alpha ? /[^A-Za-z0-9]/ : /[^0-9]/
    ransacker ransacker_name.to_sym, formatter: proc { |v| v.strip.gsub regex, '' } do |parent|
      parent.table[cell_name.to_sym]
    end
  end
end