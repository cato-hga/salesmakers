# == Schema Information
#
# Table name: attachments
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  attachable_id   :integer          not null
#  attachable_type :string           not null
#  attachment_uid  :string
#  attachment_name :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  person_id       :integer          not null
#

class Attachment < ActiveRecord::Base
  validates :attachable, presence: true
  validates :name, presence: true
  validates :person, presence: true

  dragonfly_accessor :attachment

  belongs_to :attachable, polymorphic: true
  belongs_to :person
end
