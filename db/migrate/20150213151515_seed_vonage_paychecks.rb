class SeedVonagePaychecks < ActiveRecord::Migration
  def self.up
    paychecks = get_paychecks
    for paycheck in paychecks do
      VonagePaycheck.create paycheck
    end
  end

  def self.down
    VonagePaycheck.destroy_all
  end

  private

  def get_paychecks
    [
        {
            name: '2015-02-01 through 2015-02-15',
            wages_start: Date.new(2015, 2, 1),
            wages_end: Date.new(2015, 2, 15),
            commission_start: Date.new(2015, 1, 26),
            commission_end: Date.new(2015, 2, 8),
            cutoff: DateTime.new(2015, 2, 16, 14, 30, 00, '-5')
        },
        {
            name: '2015-02-16 through 2015-02-28',
            wages_start: Date.new(2015, 2, 16),
            wages_end: Date.new(2015, 2, 28),
            commission_start: Date.new(2015, 2, 9),
            commission_end: Date.new(2015, 2, 22),
            cutoff: DateTime.new(2015, 3, 1, 14, 30, 00, '-5')
        },
        {
            name: '2015-03-01 through 2015-03-15',
            wages_start: Date.new(2015, 3, 1),
            wages_end: Date.new(2015, 3, 15),
            commission_start: Date.new(2015, 2, 23),
            commission_end: Date.new(2015, 3, 15),
            cutoff: DateTime.new(2015, 3, 16, 14, 30, 00, '-4')
        },
        {
            name: '2015-03-16 through 2015-03-31',
            wages_start: Date.new(2015, 3, 16),
            wages_end: Date.new(2015, 3, 31),
            commission_start: Date.new(2015, 3, 16),
            commission_end: Date.new(2015, 3, 29),
            cutoff: DateTime.new(2015, 4, 1, 14, 30, 00, '-4')
        },
        {
            name: '2015-04-01 through 2015-04-15',
            wages_start: Date.new(2015, 4, 1),
            wages_end: Date.new(2015, 4, 15),
            commission_start: Date.new(2015, 3, 30),
            commission_end: Date.new(2015, 4, 12),
            cutoff: DateTime.new(2015, 4, 16, 14, 30, 00, '-4')
        },
        {
            name: '2015-04-16 through 2015-04-30',
            wages_start: Date.new(2015, 4, 16),
            wages_end: Date.new(2015, 4, 30),
            commission_start: Date.new(2015, 4, 13),
            commission_end: Date.new(2015, 4, 26),
            cutoff: DateTime.new(2015, 5, 1, 14, 30, 00, '-4')
        },
        {
            name: '2015-05-01 through 2015-05-15',
            wages_start: Date.new(2015, 5, 1),
            wages_end: Date.new(2015, 5, 15),
            commission_start: Date.new(2015, 4, 27),
            commission_end: Date.new(2015, 5, 10),
            cutoff: DateTime.new(2015, 5, 16, 14, 30, 00, '-4')
        },
        {
            name: '2015-05-16 through 2015-05-31',
            wages_start: Date.new(2015, 5, 16),
            wages_end: Date.new(2015, 5, 31),
            commission_start: Date.new(2015, 5, 11),
            commission_end: Date.new(2015, 5, 31),
            cutoff: DateTime.new(2015, 6, 1, 14, 30, 00, '-4')
        },
        {
            name: '2015-06-01 through 2015-06-15',
            wages_start: Date.new(2015, 6, 1),
            wages_end: Date.new(2015, 6, 15),
            commission_start: Date.new(2015, 6, 1),
            commission_end: Date.new(2015, 6, 14),
            cutoff: DateTime.new(2015, 6, 16, 14, 30, 00, '-4')
        },
        {
            name: '2015-06-16 through 2015-06-30',
            wages_start: Date.new(2015, 6, 16),
            wages_end: Date.new(2015, 6, 30),
            commission_start: Date.new(2015, 6, 15),
            commission_end: Date.new(2015, 6, 28),
            cutoff: DateTime.new(2015, 7, 1, 14, 30, 00, '-4')
        },
        {
            name: '2015-07-01 through 2015-07-15',
            wages_start: Date.new(2015, 7, 1),
            wages_end: Date.new(2015, 7, 15),
            commission_start: Date.new(2015, 6, 29),
            commission_end: Date.new(2015, 7, 12),
            cutoff: DateTime.new(2015, 7, 16, 14, 30, 00, '-4')
        },
        {
            name: '2015-07-16 through 2015-07-31',
            wages_start: Date.new(2015, 7, 16),
            wages_end: Date.new(2015, 7, 31),
            commission_start: Date.new(2015, 7, 13),
            commission_end: Date.new(2015, 7, 26),
            cutoff: DateTime.new(2015, 8, 1, 14, 30, 00, '-4')
        },
        {
            name: '2015-08-01 through 2015-08-15',
            wages_start: Date.new(2015, 8, 1),
            wages_end: Date.new(2015, 8, 15),
            commission_start: Date.new(2015, 7, 27),
            commission_end: Date.new(2015, 8, 9),
            cutoff: DateTime.new(2015, 8, 16, 14, 30, 00, '-4')
        },
        {
            name: '2015-08-16 through 2015-08-31',
            wages_start: Date.new(2015, 8, 16),
            wages_end: Date.new(2015, 8, 31),
            commission_start: Date.new(2015, 8, 10),
            commission_end: Date.new(2015, 8, 30),
            cutoff: DateTime.new(2015, 9, 1, 14, 30, 00, '-4')
        },
        {
            name: '2015-09-01 through 2015-09-15',
            wages_start: Date.new(2015, 9, 1),
            wages_end: Date.new(2015, 9, 15),
            commission_start: Date.new(2015, 8, 31),
            commission_end: Date.new(2015, 9, 13),
            cutoff: DateTime.new(2015, 9, 16, 14, 30, 00, '-4')
        },
        {
            name: '2015-09-16 through 2015-09-30',
            wages_start: Date.new(2015, 9, 16),
            wages_end: Date.new(2015, 9, 30),
            commission_start: Date.new(2015, 9, 14),
            commission_end: Date.new(2015, 9, 27),
            cutoff: DateTime.new(2015, 10, 1, 14, 30, 00, '-4')
        },
        {
            name: '2015-10-01 through 2015-10-15',
            wages_start: Date.new(2015, 10, 1),
            wages_end: Date.new(2015, 10, 15),
            commission_start: Date.new(2015, 9, 28),
            commission_end: Date.new(2015, 10, 11),
            cutoff: DateTime.new(2015, 10, 16, 14, 30, 00, '-4')
        },
        {
            name: '2015-10-16 through 2015-10-31',
            wages_start: Date.new(2015, 10, 16),
            wages_end: Date.new(2015, 10, 31),
            commission_start: Date.new(2015, 10, 12),
            commission_end: Date.new(2015, 10, 25),
            cutoff: DateTime.new(2015, 11, 1, 14, 30, 00, '-5')
        },
        {
            name: '2015-11-01 through 2015-11-15',
            wages_start: Date.new(2015, 11, 1),
            wages_end: Date.new(2015, 11, 15),
            commission_start: Date.new(2015, 10, 26),
            commission_end: Date.new(2015, 11, 15),
            cutoff: DateTime.new(2015, 11, 16, 14, 30, 00, '-5')
        },
        {
            name: '2015-11-16 through 2015-11-30',
            wages_start: Date.new(2015, 11, 16),
            wages_end: Date.new(2015, 11, 30),
            commission_start: Date.new(2015, 11, 16),
            commission_end: Date.new(2015, 11, 29),
            cutoff: DateTime.new(2015, 12, 1, 14, 30, 00, '-5')
        },
        {
            name: '2015-12-01 through 2015-12-15',
            wages_start: Date.new(2015, 12, 1),
            wages_end: Date.new(2015, 12, 15),
            commission_start: Date.new(2015, 11, 30),
            commission_end: Date.new(2015, 12, 13),
            cutoff: DateTime.new(2015, 12, 16, 14, 30, 00, '-5')
        },
        {
            name: '2015-12-16 through 2015-12-31',
            wages_start: Date.new(2015, 12, 16),
            wages_end: Date.new(2015, 12, 31),
            commission_start: Date.new(2015, 12, 14),
            commission_end: Date.new(2015, 12, 27),
            cutoff: DateTime.new(2016, 1, 1, 14, 30, 00, '-5')
        },
    ]
  end
end
