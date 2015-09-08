# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#

class Client < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 2 }

  has_many :projects
  has_many :day_sales_counts, as: :saleable

  strip_attributes

  def self.vonage?(person)
    name_includes_string? person, 'Vonage'
  end

  def self.sprint?(person)
    name_includes_string? person, 'Sprint'
  end

  def self.name_includes_string?(person, string)
    person.clients.each do |client|
      return true if client.name.include?(string)
    end
    false
  end
end
