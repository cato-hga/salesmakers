module AreasHelper
  def nested_areas(areas)
      areas.map do |area, sub_areas|
        if sub_areas.empty?
          sub_area_content = ''
          @is_empty = true
        else
          sub_area_content = content_tag(:ul, nested_areas(sub_areas), class: 'nested_areas')
          @is_empty = false
        end
        render(area) + sub_area_content
      end.join.html_safe
  end
end
