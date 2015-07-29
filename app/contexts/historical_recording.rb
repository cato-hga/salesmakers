class HistoricalRecording
  def record
    scripts = [
        'historical_area_records.etl',
        'historical_location_records.etl',
        'historical_person_records.etl'
    ]

    for script in scripts do
      script_filename = Rails.root.join('lib', 'etl', script).to_s
      etl_script = IO.read(script_filename)
      job = Kiba.parse etl_script, script_filename
      Kiba.run job
    end

  end
end
