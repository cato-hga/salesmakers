require 'apis/groupme'
require 'apis/mojo'

class WidgetsController < ApplicationController
  layout "widget"

  def sales

  end

  def person_sales
    @person = Person.find params[ :person_id ]
    render :sales
  end

  def hours
  end

  def person_hours
    @person = Person.find params[ :person_id ]
    render :hours
  end

  def tickets
    mojo = Mojo.new
    @creator_tickets = mojo.creator_all_tickets @current_person.email, 3
  end

  def person_tickets
    @person = Person.find params[ :person_id ]
    mojo = Mojo.new
    @creator_tickets = mojo.creator_all_tickets @person.email, 1
    render :tickets
  end

  def social
  end

  def alerts
  end

  def person_alerts
    @person = Person.find params[ :person_id ]
    render :alerts
  end

  def image_gallery
  end

  def inventory
  end

  def person_inventory
    @person = Person.find params[ :person_id ]
    render :inventory
  end

  def staffing
  end

  def gaming
  end

  def commissions
  end

  def training
  end

  def gift_cards
  end

  def person_gift_cards
    @person = Person.find params[ :person_id ]
    render :gift_cards
  end

  def pnl

  end

  def person_pnl
    @person = Person.find params[ :person_id ]
    render :pnl
  end

  def hps

  end

  def person_hps
    @person = Person.find params[ :person_id ]
    render :hps
  end

  def assets

  end

  def person_assets
    @person = Person.find params[ :person_id ]
    render :assets
  end

  def groupme_slider
    groupme = GroupMe.new current_user.groupme_access_token
    messages = groupme.get_recent_messages 10, 3
    messages = messages.sort
    @messages = (messages.count < 15) ? messages.reverse : messages[0..14].reverse
    render :groupme_slider, layout: nil
  end
end
