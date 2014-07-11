class WidgetsController < ApplicationController
  layout "widget"
  require 'apis/mojo'

  def sales
  end

  def hours
  end

  def tickets
    mojo = Mojo.new
    @creator_tickets = mojo.creator_all_tickets @current_person.email, 3
  end

  def social
  end

  def alerts
  end

  def image_gallery
  end

  def inventory
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
end
