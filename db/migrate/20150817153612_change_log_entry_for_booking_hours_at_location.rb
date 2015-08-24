class ChangeLogEntryForBookingHoursAtLocation < ActiveRecord::Migration
  def change
    ChangelogEntry.create heading: 'Location profile page changes',
                          description: 'On any given Location screen, there will be sections that show the active candidates assigned to that location, and any candidate that has booked hours (within two weeks) at that location',
                          released: DateTime.now,
                          all_hq: true
  end
end