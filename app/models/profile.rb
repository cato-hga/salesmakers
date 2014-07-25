class Profile < ActiveRecord::Base
  before_validation :set_defaults

  validates :person, presence: true

  belongs_to :person

  private

  def set_defaults

  end
end
