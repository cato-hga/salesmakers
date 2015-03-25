class Screening < ActiveRecord::Base
  after_save :set_candidate_status

  enum sex_offender_check: [
           :sex_offender_check_incomplete,
           :sex_offender_check_failed,
           :sex_offender_check_passed
       ]
  enum public_background_check: [
           :public_background_check_incomplete,
           :public_background_check_failed,
           :public_background_check_passed
       ]
  enum private_background_check: [
           :private_background_check_not_initiated,
           :private_background_check_initiated,
           :private_background_check_failed,
           :private_background_check_passed
       ]
  enum drug_screening: [
           :drug_screening_not_sent,
           :drug_screening_sent,
           :drug_screening_failed,
           :drug_screening_passed
       ]

  validates :person, presence: true
  validates :sex_offender_check, inclusion: { in: Screening.sex_offender_checks }
  validates :public_background_check, inclusion: { in: Screening.public_background_checks }
  validates :private_background_check, inclusion: { in: Screening.private_background_checks }
  validates :drug_screening, inclusion: { in: Screening.drug_screenings }
  belongs_to :person

  def complete?
    get_pass_fails == 4
  end

  def partially_complete?
    get_pass_fails > 0
  end

  def none_selected?
    selected = 0
    selected += 1 if Screening.sex_offender_checks[sex_offender_check] != 0
    selected += 1 if Screening.public_background_checks[public_background_check] != 0
    selected += 1 if Screening.private_background_checks[private_background_check] != 0
    selected += 1 if Screening.drug_screenings[drug_screening] != 0
    selected == 0
  end

  def failed?
    get_fails > 0
  end

  private

  def get_pass_fails
    pass_fails = 0
    [sex_offender_check, public_background_check, private_background_check, drug_screening].each do |r|
      pass_fails += 1 if r.include?('passed') or r.include?('failed')
    end
    pass_fails
  end

  def get_fails
    fails = 0
    [sex_offender_check, public_background_check, private_background_check, drug_screening].each do |r|
      fails += 1 if r.include?('failed')
    end
    fails
  end

  def set_candidate_status
    return unless self.person
    candidate = self.person.candidate || return
    if get_fails > 0
      reason = CandidateDenialReason.find_by name: 'Did not pass employment screening'
      candidate.update candidate_denial_reason: reason,
                       status: :rejected,
                       active: false
    else
      candidate.partially_screened! if partially_complete? and not candidate.partially_screened?
      candidate.fully_screened! if complete? and not candidate.fully_screened?
    end

  end
end
