class Vonage32DaySalesSender
  def self.send_report
    script_filename = Rails.root.join('lib', 'etl', 'vonage_32-day_sales_sender.etl').to_s
    etl_script = IO.read(script_filename)
    job = Kiba.parse etl_script, script_filename
    Kiba.run job
  end
end