class WorkmarketAssignment < ActiveRecord::Base
  before_save :namecase

  validates :project, presence: true
  validates :json, length: { minimum: 2 }
  validates :workmarket_assignment_num, presence: true
  validates :title, length: { minimum: 1 }
  validates :worker_name, length: { minimum: 3 }
  validates :worker_email, length: { minimum: 1 }
  validates :cost, numericality: { greater_than_or_equal_to: 0 }
  validates :started, presence: true
  validates :ended, presence: true
  validates :workmarket_location_num, length: { minimum: 1 }

  belongs_to :project
  belongs_to :workmarket_location,
             foreign_key: :workmarket_location_num,
             primary_key: :workmarket_location_num
  has_many :workmarket_attachments
  has_many :workmarket_fields

  private

  def namecase
    self.worker_name = NameCase(self.worker_name) if self.worker_name
    self.worker_first_name = NameCase(self.worker_first_name) if self.worker_first_name
    self.worker_last_name = NameCase(self.worker_last_name) if self.worker_last_name
  end

end