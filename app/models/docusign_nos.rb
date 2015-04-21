class DocusignNos < ActiveRecord::Base

  validates :eligible_to_rehire, inclusion: { in: [true, false] }
  validates :employment_end_reason_id, presence: true
  validates :envelope_guid, presence: true
  validates :last_day_worked, presence: true
  validates :person_id, presence: true
  validates :termination_date, presence: true

  belongs_to :person
  belongs_to :employment_end_reason

end
