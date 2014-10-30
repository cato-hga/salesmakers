class ProfileExperience < ActiveRecord::Base
  before_save :clear_end_for_currently_employed
  belongs_to :profile

  validates :company_name, presence: true
  validates :title, presence: true
  validates :location, presence: true
  validates :started, presence: true
  validates :ended, presence: true, unless: :currently_employed?

  default_scope{ order currently_employed: :desc, ended: :desc }

  private

    def clear_end_for_currently_employed
      self.ended = nil if self.currently_employed?
    end
end
