class CreateChangeLogForLineReactivation < ActiveRecord::Migration
  def change
    ChangelogEntry.create heading: 'Ability to activate lines',
                          description: 'Lines can now be activated or reactivated from their individual pages in SalesCenter',
                          released: DateTime.now,
                          department_id: 9

  end
end
