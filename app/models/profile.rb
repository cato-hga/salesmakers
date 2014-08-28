class Profile < ActiveRecord::Base
  before_validation :set_defaults, :nullify_values

  validates :person, presence: true

  belongs_to :person
  has_many :profile_educations
  has_many :profile_experiences
  has_many :profile_skills

  private

    def set_defaults

    end

    def nullify_values
      self.theme_name = nil unless self.theme_name and self.theme_name.length > 0
    end
end
