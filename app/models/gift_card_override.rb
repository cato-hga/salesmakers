# == Schema Information
#
# Table name: gift_card_overrides
#
#  id                   :integer          not null, primary key
#  creator_id           :integer          not null
#  person_id            :integer
#  original_card_number :string
#  ticket_number        :string
#  override_card_number :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class GiftCardOverride < ActiveRecord::Base
  attr_accessor :import

  validates :creator, presence: true
  validates :person, presence: true, unless: :import?
  validates :original_card_number, length: { is: 16 }, unless: :ticket_number
  validates :ticket_number, presence: true, unless: :original_card_number
  validates :override_card_number, length: { is: 16 }, uniqueness: true

  belongs_to :creator, class_name: 'Person'
  belongs_to :person

  private

  def import?
    return false unless import
    import
  end
end
