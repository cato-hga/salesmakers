require 'apis/groupme'
require 'apis/mojo'

class WidgetsController < ApplicationController
  after_action :verify_authorized

  layout "widget"

  def sales
    authorize :widget, :sales?
  end

  def person_sales
    authorize :widget, :sales?
    @person = Person.find params[ :person_id ]
    render :sales
  end

  def hours
    authorize :widget, :hours?
  end

  def person_hours
    authorize :widget, :hours?
    @person = Person.find params[ :person_id ]
    render :hours
  end

  def tickets
    authorize :widget, :tickets?
    mojo = Mojo.new
    @creator_tickets = mojo.creator_all_tickets @current_person.email, 3
  end

  def person_tickets
    authorize :widget, :tickets?
    @person = Person.find params[ :person_id ]
    mojo = Mojo.new
    @creator_tickets = mojo.creator_all_tickets @person.email, 1
    render :tickets
  end

  def social
    authorize :widget, :social?
  end

  def alerts
    authorize :widget, :alerts?
  end

  def person_alerts
    authorize :widget, :alerts?
    @person = Person.find params[ :person_id ]
    render :alerts
  end

  def image_gallery
    authorize :widget, :image_gallery?
  end

  def inventory
    authorize :widget, :inventory?
  end

  def person_inventory
    authorize :widget, :inventory?
    @person = Person.find params[ :person_id ]
    render :inventory
  end

  def staffing
    authorize :widget, :staffing?
  end

  def gaming
    authorize :widget, :gaming?
  end

  def commissions
    authorize :widget, :commissions?
  end

  def training
    authorize :widget, :training?
  end

  def gift_cards
    authorize :widget, :gift_cards?
  end

  def person_gift_cards
    authorize :widget, :gift_cards?
    @person = Person.find params[ :person_id ]
    render :gift_cards
  end

  def pnl
    authorize :widget, :pnl?
  end

  def person_pnl
    authorize :widget, :pnl?
    @person = Person.find params[ :person_id ]
    render :pnl
  end

  def hps
    authorize :widget, :hps?
  end

  def person_hps
    authorize :widget, :hps?
    @person = Person.find params[ :person_id ]
    render :hps
  end

  def assets
    authorize :widget, :assets?
  end

  def person_assets
    authorize :widget, :assets?
    @person = Person.find params[ :person_id ]
    render :assets
  end

  def groupme_slider
    authorize :widget, :groupme_slider?
    groupme = GroupMe.new current_user.groupme_access_token
    messages = groupme.get_recent_messages 10, 3
    messages = messages.sort
    @messages = (messages.count < 15) ? messages.reverse : messages[0..14].reverse
    render :groupme_slider, layout: nil
  end
end
