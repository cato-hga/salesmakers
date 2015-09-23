class RingCentralCallLogger
  def self.log
    script_filename = Rails.root.join('lib', 'etl', 'ring_central_call_logger.etl').to_s
    etl_script = IO.read(script_filename)
    job = Kiba.parse etl_script, script_filename
    Kiba.run job
  end
end