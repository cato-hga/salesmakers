require 'rails_helper'
require 'apis/mojo'

describe 'Mojo API' do
  let(:mojo) { Mojo.new }

  it 'should get a ticket', :vcr do
    ticket = mojo.get_ticket 8001791
    expect(ticket).not_to be nil
  end

  it 'should have the correct user id', :vcr do
    ticket = mojo.get_ticket 7959766
    expect(ticket['user_id']).to be 1090987
  end

  it 'should get all tickets for creators', :vcr do
    tickets = mojo.creator_all_tickets 'smiles@retaildoneright.com'
    expect(tickets.count).to be > 0
  end


  it 'should get tickets only for specified creator', :vcr do
    tickets = mojo.creator_all_tickets 'smiles@retaildoneright.com'
    expect(tickets.count).to be > 0
    for ticket in tickets do
      expect(ticket['ticket']['user_id']).to be 641491
    end
  end
end