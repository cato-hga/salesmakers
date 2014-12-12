class LockExistingLineAndDeviceStates < ActiveRecord::Migration
  def self.up
    change_locked_status true
  end

  def self.down
    change_locked_status false
  end

  def change_locked_status(locked)
    states = DeviceState.where('name = ? ' +
                                   'OR name = ? ' +
                                   'OR name = ? ' +
                                   'OR name = ? ' +
                                   'OR name = ? ',
                               'Deployed',
                               'Repairing',
                               'Written Off',
                               'Exchanging',
                               'Lost or Stolen')
    for state in states do
      state.update locked: locked
    end

    states = LineState.where('name = ? ' +
                                 'OR name = ? ',
                             'Active',
                             'Suspended')
    for state in states do
      state.update locked: locked
    end
  end
end
