# == Schema Information
#
# Table name: headquarters_org_chart_entries
#
#  id              :integer          primary key
#  department_name :string
#  department_id   :integer
#  position_name   :string
#  position_id     :integer
#  person_name     :string
#  person_id       :integer
#

class HeadquartersOrgChartEntry < ActiveRecord::Base
  self.primary_key = :id
end
