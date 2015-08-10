class WidgetPolicy < Struct.new(:person, :widget)

  def sales?
    has_permission? 'sales'
  end

  def hours?
    has_permission? 'hours'
  end

  def tickets?
    has_permission? 'tickets'
  end

  def social?
    has_permission? 'social'
  end

  def alerts?
    has_permission? 'alerts'
  end

  def image_gallery?
    has_permission? 'image_gallery'
  end

  def inventory?
    has_permission? 'inventory'
  end

  def staffing?
    has_permission? 'staffing'
  end

  def gaming?
    has_permission? 'gaming'
  end

  def commissions?
    has_permission? 'commissions'
  end

  def training?
    has_permission? 'training'
  end

  def gift_cards?
    has_permission? 'gift_cards'
  end

  def pnl?
    has_permission? 'pnl'
  end

  def hps?
    has_permission? 'hps'
  end

  def assets?
    has_permission? 'assets'
  end

  def groupme_slider?
    has_permission? 'groupme_slider'
  end

  private

    def has_permission?(permission_name)
      key = 'widget_' + permission_name
      return false unless person and person.position
      permission = Permission.find_by key: key
      return false unless permission
      person.position.permissions.include? permission
    end
end
