class Attachment < ActiveRecord::Base
  validates :attachable, presence: true
  validates :name, presence: true
  validates :person, presence: true

  dragonfly_accessor :attachment

  belongs_to :attachable, polymorphic: true
  belongs_to :person
end