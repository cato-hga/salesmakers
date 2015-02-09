class Client < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 2 }

  has_many :projects
  has_many :day_sales_counts, as: :saleable

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
