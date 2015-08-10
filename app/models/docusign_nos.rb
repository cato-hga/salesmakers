# == Schema Information
#
# Table name: docusign_noses
#
#  id                       :integer          not null, primary key
#  person_id                :integer          not null
#  eligible_to_rehire       :boolean          default(FALSE), not null
#  termination_date         :datetime
#  last_day_worked          :datetime
#  employment_end_reason_id :integer
#  remarks                  :text
#  envelope_guid            :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  third_party              :boolean          default(FALSE), not null
#  manager_id               :integer
#

class DocusignNos < ActiveRecord::Base

  validates :eligible_to_rehire, inclusion: { in: [true, false] }, unless: :third_party
  validates :employment_end_reason_id, presence: true, unless: :third_party
  validates :envelope_guid, presence: true, unless: :third_party
  validates :last_day_worked, presence: true, unless: :third_party
  validates :person_id, presence: true
  validates :termination_date, presence: true, unless: :third_party
  validates :manager_id, presence: true, if: :third_party?

  belongs_to :person
  belongs_to :employment_end_reason
  belongs_to :manager, class: Person

  private

  def third_party?
    third_party == true
  end
end
