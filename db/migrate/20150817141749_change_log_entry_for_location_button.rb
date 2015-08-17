class ChangeLogEntryForLocationButton < ActiveRecord::Migration
  def change
    ChangelogEntry.create heading: 'Candidate Location button now available',
                          description: 'On the candidate profile page, there will a "Candidate Location" button that will take you to the candidates selected location, if applicable',
                          released: DateTime.now,
                          all_hq: true
  end
end
