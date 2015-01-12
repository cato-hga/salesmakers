class SMSMessage < ActiveRecord::Base
  validates :from_num, length: { is: 10 }
  validates :to_num, length: { is: 10 }
  validates :message, presence: true

  belongs_to :to_person, class_name: 'Person', foreign_key: 'to_person_id'
  belongs_to :from_person, class_name: 'Person', foreign_key: 'from_person_id'
end
