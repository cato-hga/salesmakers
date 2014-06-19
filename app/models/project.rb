class Project < ActiveRecord::Base

  validates :name, presence: true, length: { minimum: 4 }
  validates :client, presence: true

  belongs_to :client
end
