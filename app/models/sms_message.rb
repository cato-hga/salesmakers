class SMSMessage < ActiveRecord::Base
  validates :from_num, length: { is: 10 }
  validates :to_num, length: { is: 10 }
  validates :message, presence: true
end
