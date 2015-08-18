class CreateChangeLogForTrainingSessionStatusChange < ActiveRecord::Migration
  def change
    ChangelogEntry.create heading: '"Rescheduled" Training Session Status is now "Future Training Class"',
                          description: 'The rescheduled training session status has been renamed',
                          released: DateTime.now,
                          all_hq: true
  end
end
