module PeopleHelper
  def people_nested_areas(areas)
    areas.map do |area, sub_areas|
      if sub_areas.empty?
        sub_area_content = ''
        @is_empty = true
      else
        sub_area_content = content_tag(:ul, people_nested_areas(sub_areas))
        @is_empty = false
      end
      render(partial: 'people/org_chart_area', locals: { area: area, sub_area_content: sub_area_content })
    end.join.html_safe
  end
end
