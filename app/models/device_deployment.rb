class DeviceDeployment < ActiveRecord::Base

  validates :device, presence: true
  validates :person, presence: true
  validates :started, presence: true

  belongs_to :device
  belongs_to :person

  default_scope { order('started DESC') }

  def recoup(notes, ended = Time.zone.now)
    deployed = DeviceState.find_by name: 'Deployed'
    @device = self.device
    @person = @device.person
    @notes = notes
    @device.device_states.delete deployed
    ended = ended
    self.update ended: ended
    #DeviceRecoupMailer.recoup_mailer(@device, @person, @notes).deliver #Don't forget to uncomment test in device_deployments_controller spec
    @device.update person_id: nil
  end
end
