# == Schema Information
#
# Table name: location_areas
#
#  id                        :integer          not null, primary key
#  location_id               :integer          not null
#  area_id                   :integer          not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  current_head_count        :integer          default(0), not null
#  potential_candidate_count :integer          default(0), not null
#  target_head_count         :integer          default(0), not null
#  active                    :boolean          default(TRUE), not null
#  hourly_rate               :float
#  offer_extended_count      :integer          default(0), not null
#  outsourced                :boolean          default(FALSE), not null
#  launch_group              :integer
#  distance_to_cor           :float
#  priority                  :integer
#

class LocationArea < ActiveRecord::Base
  validates :location, presence: true
  validates :area, presence: true, uniqueness: { scope: :location,
                                                 message: 'is already assigned that location' }

  belongs_to :location
  belongs_to :area
  has_and_belongs_to_many :radio_shack_location_schedules
  has_many :candidates
  has_many :day_sales_counts, as: :saleable

  has_paper_trail

  searchable do
    text :display_name, boost: 4.0 do
      location.display_name
    end
    text :channel, boost: 3.0 do
      location.channel.name
    end
    text :store_number, boost: 7.0 do
      location.store_number
    end
    text :city, boost: 5.0 do
      location.city
    end
    text :state, boost: 5.0 do
      location.state
    end
    text :street_1, boost: 6.0 do
      location.street_1
    end
    text :zip, boost: 7.0 do
      location.zip
    end
    text :cost_center, boost: 7.0 do
      location.cost_center
    end
    text :mail_stop, boost: 7.0 do
      location.mail_stop
    end
  end

  default_scope {
    joins(:area).joins(:location).order("areas.name, locations.display_name")
  }

  def self.for_project_and_location(project, location)
    location.location_areas.joins(:area).where("areas.project_id = ?", project.id)
  end

  def head_count_full?
    return true unless self.priority == 1
    candidates = number_of_candidates_in_funnel
    return true if self.target_head_count + 1 <= candidates
    false
  end

  def number_of_candidates_in_funnel
    paperwork_sent_since_june_22 = ActiveRecord::Base.connection.execute(
        %{
          select
          c.id
          from location_areas la
          left outer join candidates c
            on c.location_area_id = la.id
          left outer join job_offer_details j
          on j.sent >= cast('06/22/2015' as timestamp)
          where j.id is not null
            and la.id = #{self.id}
            and c.status >= #{Candidate.statuses[:paperwork_sent]}
            and c.active = true
          group by c.id
          order by c.id
        }
    ).values.flatten
    in_class_for_629 = ActiveRecord::Base.connection.execute(
        %{
          select
          c.id
          from location_areas la
          left outer join candidates c
            on c.location_area_id = la.id
          where c.sprint_radio_shack_training_session_id = 17
            and (c.training_session_status = #{Candidate.training_session_statuses[:in_class]})
            and la.id = #{self.id}
            and c.active = true
        }
    ).values.flatten
    [
        paperwork_sent_since_june_22,
        in_class_for_629,
    ].flatten.uniq.count
  end

  def self.get_all_location_areas(candidate, current_person)
    all_locations = Location.
        joins(:location_areas).
        where('location_areas.target_head_count > 0')
    return LocationArea.none if all_locations.count(:all) < 1
    all_locations = Location.where("locations.id IN (#{all_locations.map(&:id).join(',')})")
    locations = all_locations.near(candidate, 30)
    if not locations or locations.count(:all) < 5
      locations = all_locations.near(candidate, 500).first(5)
    end
    return LocationArea.none if locations.empty?
    location_areas = locations.map { |l| l.location_areas }.flatten
    LocationAreaPolicy::Scope.new(current_person, LocationArea.where("location_areas.id IN (#{location_areas.map(&:id).join(',')}) AND active = true")).resolve
  end

  def change_counts candidate_status_integer, change_by
    accepted_status_integer = Candidate.statuses['accepted']
    onboarded_status_integer = Candidate.statuses['onboarded']
    self.update potential_candidate_count: self.potential_candidate_count + change_by if candidate_status_integer < onboarded_status_integer
    self.update offer_extended_count: self.offer_extended_count + change_by if candidate_status_integer < onboarded_status_integer and
        candidate_status_integer >= accepted_status_integer
    self.update current_head_count: self.current_head_count + change_by if candidate_status_integer >= onboarded_status_integer
  end
end
