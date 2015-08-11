# == Schema Information
#
# Table name: device_deployments
#
#  id              :integer          not null, primary key
#  device_id       :integer          not null
#  person_id       :integer          not null
#  started         :date             not null
#  ended           :date
#  tracking_number :string
#  comment         :text
#  created_at      :datetime
#  updated_at      :datetime
#

class DeviceDeployment < ActiveRecord::Base

  validates :device, presence: true
  validates :person, presence: true
  validates :started, presence: true

  belongs_to :device
  belongs_to :person
  has_many :log_entries, as: :trackable, dependent: :destroy


  default_scope { order('started DESC') }

  def recoup(notes, ended = Time.zone.now)
    deployed = DeviceState.find_by name: 'Deployed'
    @device = self.device
    @person = @device.person
    @notes = notes
    @device.device_states.delete deployed
    ended = ended
    self.update ended: ended,
                comment: @notes
    AssetsMailer.recoup_mailer(@device, @person, @notes).deliver_later
    @device.update person_id: nil
  end
end
