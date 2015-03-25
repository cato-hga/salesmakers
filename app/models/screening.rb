class Screening < ActiveRecord::Base
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
end
