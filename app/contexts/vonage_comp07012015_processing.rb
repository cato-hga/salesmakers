class VonageComp07012015Processing
  def execute
    hps_sales_filename = Rails.root.join('lib', 'etl', 'vonage_comp07012015_hps_sales.etl').to_s
    vested_sales_sales_filename = Rails.root.join('lib', 'etl', 'vonage_comp07012015_vested_sales_sales.etl').to_s
    hps_shifts_filename = Rails.root.join('lib', 'etl', 'vonage_comp07012015_hps_shifts.etl').to_s
    vested_sales_shifts_filename = Rails.root.join('lib', 'etl', 'vonage_comp07012015_vested_sales_shifts.etl').to_s

    for script_filename in [
        hps_sales_filename,
        vested_sales_sales_filename,
        hps_shifts_filename,
        vested_sales_shifts_filename] do
      etl_script = IO.read(script_filename)
      job = Kiba.parse etl_script, script_filename
      Kiba.run job
    end
  end
end