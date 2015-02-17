class ChangeVonageOwnedRetailName < ActiveRecord::Migration
  def self.up
    area = Area.find_by(name: 'Vonage Retail - Vonage Owned Retail') || return
    area.update name: 'Vonage Owned Retail'
  end

  def self.down
    area = Area.find_by(name: 'Vonage Owned Retail') || return
    area.update name: 'Vonage Retail - Vonage Owned Retail'
  end
end
