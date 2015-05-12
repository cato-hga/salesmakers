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
  has_many :workmarket_attachments, dependent: :destroy
  has_many :workmarket_fields, dependent: :destroy

  default_scope { order started: :desc, ended: :desc, title: :asc }

  scope :for_client, ->(client) {
    return if client.nil?
    where(project: client.projects)
  }

  def location_name
    self.workmarket_location ? self.workmarket_location.name : nil
  end

  def attachment_count
    self.workmarket_attachments.count
  end

  def project_name
    self.project.name
  end

  private

  def namecase
    self.worker_name = NameCase(self.worker_name) if self.worker_name
    self.worker_first_name = NameCase(self.worker_first_name) if self.worker_first_name
    self.worker_last_name = NameCase(self.worker_last_name) if self.worker_last_name
  end

end