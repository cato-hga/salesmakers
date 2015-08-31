# == Schema Information
#
# Table name: client_representatives
#
#  id              :integer          not null, primary key
#  client_id       :integer          not null
#  name            :string           not null
#  email           :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ClientRepresentative < ActiveRecord::Base
  has_secure_password

  validates :client, presence: true
  validates :name, length: { minimum: 3 }
  validates :email, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+\z/, message: 'must be a valid email address' }, uniqueness: true
  validates :password, length: { minimum: 6 }

  belongs_to :client

  has_and_belongs_to_many :permissions

  strip_attributes
end
