class HistoricalRecording
  def record
    return if RunningProcess.running? self
    begin
      RunningProcess.running! self
      scripts = [
          'historical_area_records.etl',
          'historical_location_records.etl',
          'historical_person_records.etl',
          'historical_person_area_records.etl',
          'historical_location_area_records.etl',
          'historical_client_area_records.etl',
          'historical_location_client_area_records.etl',
          'historical_person_client_area_records.etl',
      ]

      for script in scripts do
        script_filename = Rails.root.join('lib', 'etl', script).to_s
        etl_script = IO.read(script_filename)
        job = Kiba.parse etl_script, script_filename
        Kiba.run job
      end
    ensure
      RunningProcess.shutdown! self
    end
  end
end
