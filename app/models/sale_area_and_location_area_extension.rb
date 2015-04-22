module SaleAreaAndLocationAreaExtension
  def location_area_for_sale(project_name_contains)
    location = self.location || return
    location.location_areas.each do |location_area|
      if location_area.area.project.name.include?(project_name_contains)
        return location_area
      end
    end
    nil
  end

  def area
    location_area = self.location_area || return
    location_area.area
  end
end