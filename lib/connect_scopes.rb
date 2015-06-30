module ConnectScopes
  def self.included base
    base.instance_eval "
      scope :updated_within_last, ->(duration) {
        if duration
          where('updated >= ?', (Time.zone.now - duration).apply_eastern_offset).order(:ad_user_id, :shift_date)
        else
          none
        end
      }
    "
  end
end