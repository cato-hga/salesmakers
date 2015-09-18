# == Schema Information
#
# Table name: abstract_prescreen_answers
#
#  id           :integer          not null, primary key
#  candidate_id :integer          not null
#  person_id    :integer          not null
#  project_id   :integer          not null
#  answers      :json             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class AbstractPrescreenAnswer < ActiveRecord::Base
  validates :candidate, presence: true
  validates :person, presence: true
  validates :project, presence: true
  validates :answers, presence: true

  belongs_to :candidate
  belongs_to :person
  belongs_to :project
end
