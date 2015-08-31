class CreateChangeLogEntryForPeopleHours < ActiveRecord::Migration
  def change
    ChangelogEntry.create heading: 'Hours by Project',
                          description: 'The hours booked by a SalesMaker are now available, broken down by project, on their respective profile page',
                          released: DateTime.now,
                          all_hq: true
  end
end
