class LocationArea < ActiveRecord::Base
  validates :location, presence: true
  validates :area, presence: true, uniqueness: {scope: :location,
                                                message: 'is already assigned that location'}

  belongs_to :location
  belongs_to :area
  has_and_belongs_to_many :radio_shack_location_schedules
  has_many :candidates
  has_many :day_sales_counts, as: :saleable

  has_paper_trail

  #default_scope { where(active: true) }

  def self.for_project_and_location(project, location)
    location.location_areas.joins(:area).where("areas.project_id = ?", project.id)
  end

  def head_count_full?
    get_recent_people
    return true if (self.target_head_count - @recent_people.count) <= 0
    get_booked_recent_candidates
    return true if (self.target_head_count - @booked_recent_candidates.count) <= 0
    false
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

  private

  def get_recent_people
    recent_shifts = Shift.where('location_id = ? and (date < ? and date > ?)', self.location.id, Date.today, Date.today - 7.days)
    @recent_people = []
    for shift in recent_shifts do
      @recent_people << shift.person unless @recent_people.include? shift.person or shift.person.active == false
    end
  end

  def get_booked_recent_candidates
    location_candidates = Candidate.where(location_area: self)
    recent_trainings = SprintRadioShackTrainingSession.where("name ilike '%4/20%' or name ilike '%5/11%' or name ilike '%5/18%'")
    most_recent_training_session = SprintRadioShackTrainingSession.find_by name: '5/11 Training'
    recent_location_independent_shifts = Shift.where('date < ? and date > ?', Date.today, Date.today - 7.days)
    recent_people = []
    for shift in recent_location_independent_shifts do
      recent_people << shift.person unless recent_people.include? shift.person or shift.person.active == false
    end
    @booked_recent_candidates = []
    for candidate in location_candidates do
      @booked_recent_candidates << candidate if (recent_people.include? candidate.person and recent_trainings.include? candidate.sprint_radio_shack_training_session) and not (@booked_recent_candidates.include? candidate.person or candidate.active? == false)
      @booked_recent_candidates << candidate if (candidate.sprint_radio_shack_training_session == most_recent_training_session and candidate.training_session_status == 'candidate_confirmed') and not (@booked_recent_candidates.include? candidate.person or candidate.active? == false)
    end
  end


end
