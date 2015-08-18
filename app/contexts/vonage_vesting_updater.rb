class VonageVestingUpdater
  def update
    script_filename = Rails.root.join('lib', 'etl', 'vonage_vesting_updater.etl').to_s
    etl_script = IO.read(script_filename)
    job = Kiba.parse etl_script, script_filename
    Kiba.run job
  end
end
