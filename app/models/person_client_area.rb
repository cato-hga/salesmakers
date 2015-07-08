class PersonClientArea < ActiveRecord::Base
  validates :person, presence: true
  validates :client_area, presence: true

  belongs_to :person
  belongs_to :client_area

  has_paper_trail

  delegate :project, to: :client_area
  delegate :client, to: :client_area
end
