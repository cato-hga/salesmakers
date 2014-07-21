require 'rails_helper'
require 'apis/mojo'

describe 'Mojo API' do

  before(:all) do
    @mojo = Mojo.new
  end

  it 'should get a ticket' do
    ticket = @mojo.get_ticket 8001791
    expect(ticket).not_to be nil
  end

  it 'should have the correct user id' do
    ticket = @mojo.get_ticket 7959766
    expect(ticket['user_id']).to be 1090987
  end

  it 'should get all tickets for creators' do
    tickets = @mojo.creator_all_tickets 'smiles@retaildoneright.com'
    expect(tickets.count).to be > 0
  end

  it 'should get tickets only for specified creator' do
    tickets = @mojo.creator_all_tickets 'smiles@retaildoneright.com'
    for ticket in tickets do
      expect(ticket['ticket']['user_id']).to be 641491
    end
  end

  #TODO Test open tickets by creator
end