# == Schema Information
#
# Table name: shifts
#
#  id          :integer          not null, primary key
#  person_id   :integer          not null
#  location_id :integer
#  date        :date             not null
#  hours       :decimal(, )      not null
#  break_hours :decimal(, )      default(0.0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Shift < ActiveRecord::Base
  validates :person, presence: true
  validates :date, presence: true
  validates :hours, presence: true

  belongs_to :person
  belongs_to :location

  def self.totals_by_person_for_date_range start_date, end_date
    connection.execute %{
      select

      p.connect_user_id,
      floor(round(sum(s.hours), 2)) as hours

      from shifts s
      left outer join people p
        on p.id = s.person_id

      where
        s.date >= cast('#{start_date.strftime('%m/%d/%Y')}' as date)
        and s.date <= cast('#{end_date.strftime('%m/%d/%Y')}' as date)

      group by p.connect_user_id
      order by p.connect_user_id
    }
  end
end
