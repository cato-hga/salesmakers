class SMSDailyCheck < ActiveRecord::Base

  validates :person_id, presence: true
  validates :sms_id, presence: true
  validates :date, presence: true

  belongs_to :person, class_name: 'Person', foreign_key: 'person_id'
  belongs_to :sms, class_name: 'Person', foreign_key: 'sms_id'

end